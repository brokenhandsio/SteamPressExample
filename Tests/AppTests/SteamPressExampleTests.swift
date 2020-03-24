import XCTest
import App
import Vapor

class SteamPressExampleTests: XCTestCase {

    // MARK: - Properties
    var app: Application!

    // MARK: - Overrides
    override func setUp() {
        app = try! getApp()
    }

    // MARK: - Tests
    func testSecurityHeadersSetupCorrectly() throws {
        let response = try getResponse(to: "/", on: app)

        XCTAssertEqual(response.http.status, .ok)
        XCTAssertEqual(response.http.headers["X-Frame-Options"].first, "DENY")
    }

    func testThatAboutPageRouteAdded() throws {
        let response = try getResponse(to: "/about", on: app)

        XCTAssertEqual(response.http.status, .ok)
    }

    func testThatSteamPressSetUp() throws {
        let response = try getResponse(to: "/blog", on: app)

        XCTAssertEqual(response.http.status, .ok)
    }
    
    // MARK: - Helpers
    func getApp() throws -> Application {
        var config = Config.default()
        var services = Services.default()
        var env = Environment.testing
        try App.configure(&config, &env, &services)
        let app = try Application(config: config, environment: env, services: services)
        return app
    }
    
    func getResponse(to path: String, on app: Application) throws -> Response {
        let responder = try app.make(Responder.self)
        let request = HTTPRequest(method: .GET, url: URL(string: path)!)
        let wrappedRequest = Request(http: request, using: app)
        return try responder.respond(to: wrappedRequest).wait()
    }
}
