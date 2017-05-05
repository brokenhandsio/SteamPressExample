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
                }
                catch { /* swallow so we return the default view */ }
            }
//            let bytes = errorView.render(
//                code: status.statusCode,
//                message: status.reasonPhrase
//            )
            return View(bytes: Bytes()).makeResponse()
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

//import HTTP
//import Vapor
//
///**
// Handles the various Abort errors that can be thrown
// in any Vapor closure.
// 
// To stop this behavior, remove the
// AbortMiddleware for the Droplet's `middleware` array.
// */
//public class BlogAbortMiddleware: Middleware {
//    
//    let viewRenderer: ViewRenderer
//    let environment: Environment
//    let log: LogProtocol?
//    
//    public init(viewRenderer: ViewRenderer, environment: Environment, log: LogProtocol?) {
//        self.viewRenderer = viewRenderer
//        self.environment = environment
//        self.log = log
//    }
//
//    public func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
//        do {
//            return try chain.respond(to: request)
//        } catch let error as AbortError {
//            return try errorResponse(request, error)
//        } catch {
//            let errorType = type(of: error)
//            let message = "\(errorType): \(error)"
//            do {
//                return try errorResponse(request, .internalServerError, message)
//            } catch {
//                let response = Response(status: .internalServerError, body: "There was an internal server error, please try again later.".bytes)
//                return response
//            }
//        }
//    }
//    
//    // MARK: Private
//    
//    private func errorResponse(_ request: Request, _ status: Status, _ message: String) throws -> Response {
//        let error = Abort.custom(status: status, message: message)
//        return try errorResponse(request, error)
//    }
//    
//    private func errorResponse(_ request: Request, _ error: AbortError) throws -> Response {
//        self.log?.error("Uncaught Error: \(type(of: error)).\(error)")
//        
//        var params: [String: NodeRepresentable] = [
//            "url": request.uri.description.makeNode(),
//            "code": try error.code.makeNode(),
//            "error": true.makeNode()
//        ]
//        
//        if environment == .production {
//            params["message"] = error.code < 500 ? error.message : "Something went wrong"
//        }
//        else {
//            params["message"] = error.message.makeNode()
//            params["metadata"] = error.metadata?.makeNode()
//        }
//        
//        if request.accept.prefers("html") {
//            let body = try viewRenderer.make(error.code == 404 ? "404" : "serverError", try params.makeNode()).data
//            return Response(status: Status(officialCode: error.code) ?? .internalServerError, headers: [
//                "Content-Type": "text/html; charset=utf-8"
//                ], body: .data(body))
//        }
//        else {
//            let response = try Response(status: error.status, json: JSON(node: params))
//            return response
//        }
//        
//    }
//}
