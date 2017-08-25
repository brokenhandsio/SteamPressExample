import Vapor
import Fluent
import Sessions
import SteamPress
import Foundation
import VaporSecurityHeaders
import LeafProvider
import FluentProvider
import MySQLProvider

extension Config {
    public func setup() throws {
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupMiddleware()
        try setupProviders()
    }

    private func setupMiddleware() throws {
        let disqusName = self["disqus", "disqusName"]?.string ?? "*"
        var cspConfig = "default-src 'none'; script-src 'self' https://static.brokenhands.io https://cdn.jsdelivr.net/ https://connect.facebook.net/ https://publish.twitter.com cdn.syndication.twimg.com platform.twitter.com https://platform.linkedin.com https://ajax.googleapis.com/ https://code.jquery.com/ https://cdnjs.cloudflare.com/ https://maxcdn.bootstrapcdn.com/ https://\(disqusName).disqus.com/ https://a.disquscdn.com/; style-src 'self' https://cdn.jsdelivr.net/ *.twimg.com platform.twitter.com https://maxcdn.bootstrapcdn.com/ https://a.disquscdn.com/ https://cdnjs.cloudflare.com/ajax/libs/select2/; img-src 'self' data: https://static.brokenhands.io https://www.facebook.com cdn.syndication.twimg.com syndication.twitter.com *.twimg.com platform.twitter.com https://referrer.disqus.com/ https://a.disquscdn.com/; connect-src 'self' https://links.services.disqus.com/; font-src https://maxcdn.bootstrapcdn.com/; child-src https://disqus.com/ syndication.twitter.com platform.twitter.com www.facebook.com staticxx.facebook.com; form-action 'self'; base-uri 'self'; require-sri-for script style;"

        if let reportUri = self["csp", "report-uri"]?.string {
            cspConfig += " report-uri \(reportUri);"
        }

        if environment == .production || environment == .test {
            cspConfig += " upgrade-insecure-requests; block-all-mixed-content;"
        }

        let referrerPolicy = ReferrerPolicyConfiguration(.strictOriginWhenCrossOrigin)

        let securityHeaders = SecurityHeadersFactory()
            .with(server: ServerConfiguration(value: "brokenhands.io"))
            .with(contentSecurityPolicy: ContentSecurityPolicyConfiguration(value: cspConfig))
            .with(referrerPolicy: referrerPolicy)
        self.addConfigurable(middleware: securityHeaders.builder(), name: "security-headers")
        self.addConfigurable(middleware: BlogErrorMiddleware.init, name: "blog-error")
    }

    private func setupProviders() throws {
        try self.addProvider(SteamPress.Provider.self)
        try self.addProvider(LeafProvider.Provider.self)
        try self.addProvider(FluentProvider.Provider.self)

        if environment == .production {
            try self.addProvider(MySQLProvider.Provider.self)
        }
    }

}
