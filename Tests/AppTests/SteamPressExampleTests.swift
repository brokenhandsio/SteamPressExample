import XCTest
import App
import Vapor

class SteamPressExampleTests: XCTestCase {

    // MARK: - All Tests
    static var allTests = [
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests),
        ("testSecurityHeadersSetupCorrectly", testSecurityHeadersSetupCorrectly),
        ("testThatAboutPageRouteAdded", testThatAboutPageRouteAdded),
        ("testThatSteamPressSetUp", testThatSteamPressSetUp)
    ]

    // MARK: - Properties
    var drop: Droplet!

    // MARK: - Overrides
    override func setUp() {
        let config = try! Config()
        try! config.setup()

        drop = try! Droplet(config)
        try! drop.setup()
    }

    // MARK: - Tests
    func testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            let thisClass = type(of: self)
            let linuxCount = thisClass.allTests.count
            let darwinCount = Int(thisClass
                .defaultTestSuite.testCaseCount)
            XCTAssertEqual(linuxCount, darwinCount,
                           "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }

    func testSecurityHeadersSetupCorrectly() throws {
        let request = Request(method: .get, uri: "/")
        let response = try drop.respond(to: request)

        XCTAssertEqual(response.status, .ok)
        XCTAssertEqual(response.headers["X-Frame-Options"], "DENY")
    }

    func testThatAboutPageRouteAdded() throws {
        let request = Request(method: .get, uri: "/about/")
        let response = try drop.respond(to: request)

        XCTAssertEqual(response.status, .ok)
    }

    func testThatSteamPressSetUp() throws {
        let request = Request(method: .get, uri: "/blog/")
        let response = try drop.respond(to: request)

        XCTAssertEqual(response.status, .ok)
    }
}
