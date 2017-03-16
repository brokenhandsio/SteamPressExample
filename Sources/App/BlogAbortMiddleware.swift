import HTTP
import Vapor

/**
 Handles the various Abort errors that can be thrown
 in any Vapor closure.
 
 To stop this behavior, remove the
 AbortMiddleware for the Droplet's `middleware` array.
 */
public class BlogAbortMiddleware: Middleware {
    let environment: Environment
    var log: LogProtocol?
    let drop: Droplet
    
    public init(drop: Droplet) {
        self.drop = drop
        self.environment = drop.environment
        self.log = drop.log
    }

    public func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        do {
            return try chain.respond(to: request)
        } catch let error as AbortError {
            return try errorResponse(request, error)
        } catch {
            let errorType = type(of: error)
            let message = "\(errorType): \(error)"
            do {
                return try errorResponse(request, .internalServerError, message)
            } catch {
                let response = Response(status: .internalServerError, body: "There was an internal server error, please try again later.".bytes)
                return response
            }
        }
    }
    
    // MARK: Private
    
    private func errorResponse(_ request: Request, _ status: Status, _ message: String) throws -> Response {
        let error = Abort.custom(status: status, message: message)
        return try errorResponse(request, error)
    }
    
    private func errorResponse(_ request: Request, _ error: AbortError) throws -> Response {
        var params: [String: NodeRepresentable] = [
            "url": request.uri.description.makeNode(),
            "code": try error.code.makeNode(),
            "error": true.makeNode()
        ]
        
        if environment == .production {
            self.log?.error("Uncaught Error: \(type(of: error)).\(error)")
            params["message"] = error.code < 500 ? error.message : "Something went wrong"
        }
        else {
            params["message"] = error.message.makeNode()
            params["metadata"] = error.metadata?.makeNode()
        }
        
        if request.accept.prefers("html") {
            let body = try drop.view.make(error.code == 404 ? "404" : "serverError", try params.makeNode()).data
            return Response(status: Status(officialCode: error.code) ?? .internalServerError, headers: [
                "Content-Type": "text/html; charset=utf-8"
                ], body: .data(body))
        }
        else {
            let response = try Response(status: error.status, json: JSON(node: params))
            return response
        }
        
    }
}
