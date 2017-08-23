import Vapor
import Fluent
import Sessions
import SteamPress
import Foundation
import VaporSecurityHeaders
import LeafProvider
import FluentProvider
import MySQLProvider

let config = try Config()
let disqusName = config["disqus", "disqusName"]?.string ?? "*"
var cspConfig = "default-src 'none'; script-src 'self' https://static.brokenhands.io https://cdn.jsdelivr.net/ https://connect.facebook.net/ https://publish.twitter.com cdn.syndication.twimg.com platform.twitter.com https://platform.linkedin.com https://ajax.googleapis.com/ https://code.jquery.com/ https://cdnjs.cloudflare.com/ https://maxcdn.bootstrapcdn.com/ https://\(disqusName).disqus.com/ https://a.disquscdn.com/; style-src 'self' https://cdn.jsdelivr.net/ *.twimg.com platform.twitter.com https://maxcdn.bootstrapcdn.com/ https://a.disquscdn.com/ https://cdnjs.cloudflare.com/ajax/libs/select2/; img-src 'self' data: https://static.brokenhands.io https://www.facebook.com cdn.syndication.twimg.com syndication.twitter.com *.twimg.com platform.twitter.com https://referrer.disqus.com/ https://a.disquscdn.com/; connect-src 'self' https://links.services.disqus.com/; font-src https://maxcdn.bootstrapcdn.com/; child-src https://disqus.com/ syndication.twitter.com platform.twitter.com www.facebook.com staticxx.facebook.com; form-action 'self'; base-uri 'self'; require-sri-for script style;"

if let reportUri = config["csp", "report-uri"]?.string {
    cspConfig += " report-uri \(reportUri);"
}

if config.environment == .production || config.environment == .test {
    cspConfig += " upgrade-insecure-requests; block-all-mixed-content;"
}

let referrerPolicy = ReferrerPolicyConfiguration(.strictOriginWhenCrossOrigin)

let securityHeaders = SecurityHeadersFactory()
    .with(server: ServerConfiguration(value: "brokenhands.io"))
    .with(contentSecurityPolicy: ContentSecurityPolicyConfiguration(value: cspConfig))
    .with(referrerPolicy: referrerPolicy)
config.addConfigurable(middleware: securityHeaders.builder(), name: "security-headers")
config.addConfigurable(middleware: BlogErrorMiddleware.init, name: "blog-error")

try config.addProvider(SteamPress.Provider.self)
try config.addProvider(LeafProvider.Provider.self)
try config.addProvider(FluentProvider.Provider.self)

if config.environment == .production {
    try config.addProvider(MySQLProvider.Provider.self)
}

let drop = try Droplet(config)
let database = try Database(MemoryDriver())

drop.get { req in
    var posts = try BlogPost.makeQuery()
        .filter(BlogPost.Properties.published, true)
        .sort(BlogPost.Properties.created, .descending)
        .limit(3).all()

    var parameters: [String: NodeRepresentable] = [
        "uri": req.uri.description
    ]

    if posts.count > 0 {
        parameters["posts"] = try posts.makeNode(in: BlogPostContext.shortSnippet)
    }

    if let twitterHandle = drop.config["twitter", "siteHandle"]?.string {
        parameters["site_twitter_handle"] = twitterHandle
    }

    return try drop.view.make("index", parameters)
}

drop.get("about") { req in

    var parameters: [String: NodeRepresentable] = [
        "about_page": true,
        "uri": req.uri.description
    ]

    if let twitterHandle = drop.config["twitter", "siteHandle"]?.string {
        parameters["site_twitter_handle"] = twitterHandle
    }

    return try drop.view.make("about", parameters)
}

try drop.run()
