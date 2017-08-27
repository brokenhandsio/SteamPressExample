import Vapor
import HTTP

public final class BlogErrorMiddleware: Middleware {
    let log: LogProtocol
    let environment: Environment
    let viewRenderer: ViewRenderer
    public init(environment: Environment, log: LogProtocol, viewRenderer: ViewRenderer) {
        self.log = log
        self.environment = environment
        self.viewRenderer = viewRenderer
    }

    public func respond(to req: Request, chainingTo next: Responder) throws -> Response {
        do {
            return try next.respond(to: req)
        } catch {
            log.error(error)
            return make(with: req, for: error)
        }
    }

    public func make(with req: Request, for error: Error) -> Response {
        guard !req.accept.prefers("html") else {
            let status: Status = Status(error)
            if status == .notFound {
                do {
                    return try viewRenderer.make("404", Node([:])).makeResponse()
                } catch { /* swallow so we return the default view */ }
            }

            let body = "<h1>" + status.statusCode.description + "</h1><p>" + status.reasonPhrase + "</p>"
            let response = Response(status: status, body: .data(body.makeBytes()))
            response.headers["Content-Type"] = "text/html; charset=utf-8"
            return response
        }

        let status = Status(error)
        let response = Response(status: status)
        response.json = JSON(error, env: environment)
        return response
    }
}

extension BlogErrorMiddleware: ConfigInitializable {
    public convenience init(config: Config) throws {
        let log = try config.resolveLog()
        let viewRenderer = try config.resolveView()
        self.init(environment: config.environment, log: log, viewRenderer: viewRenderer)
    }
}

extension Status {
    internal init(_ error: Error) {
        if let abort = error as? AbortError {
            self = abort.status
        } else {
            self = .internalServerError
        }
    }
}

extension JSON {
    fileprivate init(_ error: Error, env: Environment) {
        let status = Status(error)

        var json = JSON(["error": true])
        if let abort = error as? AbortError {
            try? json.set("reason", abort.reason)
        } else {
            try? json.set("reason", status.reasonPhrase)
        }

        guard env != .production else {
            self = json
            return
        }

        if env != .production {
            if let abort = error as? AbortError {
                try? json.set("metadata", abort.metadata)
            }

            if let debug = error as? Debuggable {
                try? json.set("debugReason", debug.reason)
                try? json.set("identifier", debug.fullIdentifier)
                try? json.set("possibleCauses", debug.possibleCauses)
                try? json.set("suggestedFixes", debug.suggestedFixes)
                try? json.set("documentationLinks", debug.documentationLinks)
                try? json.set("stackOverflowQuestions", debug.stackOverflowQuestions)
                try? json.set("gitHubIssues", debug.gitHubIssues)
            }
        }

        self = json
    }
}
