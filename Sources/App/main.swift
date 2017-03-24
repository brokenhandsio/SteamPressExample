import Vapor
import Fluent
import Sessions
import SteamPress
import Foundation
import VaporSecurityHeaders

let drop = Droplet()
let database = Database(MemoryDriver())
drop.database = database

let memory = MemorySessions()
let sessions = SessionsMiddleware(sessions: memory)
drop.middleware.append(sessions)

let disqusName = drop.config["disqus", "disqusName"]?.string ?? "*"
var cspConfig = "default-src 'none'; script-src 'self' https://static.brokenhands.io https://cdn.jsdelivr.net/ https://connect.facebook.net/ https://publish.twitter.com cdn.syndication.twimg.com platform.twitter.com https://platform.linkedin.com https://ajax.googleapis.com/ https://cdnjs.cloudflare.com/ https://maxcdn.bootstrapcdn.com/ https://\(disqusName).disqus.com/ https://a.disquscdn.com/; style-src 'self' https://cdn.jsdelivr.net/ *.twimg.com platform.twitter.com https://maxcdn.bootstrapcdn.com/ https://a.disquscdn.com/ https://cdnjs.cloudflare.com/ajax/libs/select2/; img-src 'self' data: https://static.brokenhands.io https://www.facebook.com cdn.syndication.twimg.com syndication.twitter.com *.twimg.com platform.twitter.com https://referrer.disqus.com/ https://a.disquscdn.com/; connect-src 'self' https://links.services.disqus.com/; font-src https://maxcdn.bootstrapcdn.com/; child-src https://disqus.com/ syndication.twitter.com platform.twitter.com www.facebook.com staticxx.facebook.com; form-action 'self'; base-uri 'self'; require-sri-for script style;"

if let reportUri = drop.config["csp", "report-uri"]?.string {
    cspConfig += " report-uri \(reportUri);"
}

if drop.environment == .production || drop.environment == .test {
    cspConfig += " upgrade-insecure-requests; block-all-mixed-content;"
}

let referrerPolicy = ReferrerPolicyConfiguration(.strictOriginWhenCrossOrigin)

let securityHeaders = SecurityHeaders(contentSecurityPolicyConfiguration: ContentSecurityPolicyConfiguration(value: cspConfig), referrerPolicyConfiguration: referrerPolicy)
drop.middleware.append(securityHeaders)

let abort = BlogAbortMiddleware(viewRenderer: drop.view, environment: drop.environment, log: drop.log)
drop.middleware.insert(abort, at: 0)

try drop.addProvider(SteamPress.Provider.self)

drop.get { req in
    var posts = try BlogPost.query().filter("published", true).sort("created", .descending).limit(3).all()
    
    var parameters = [
        "uri": req.uri.description.makeNode()
    ]
    
    if posts.count > 0 {
        parameters["posts"] = try posts.makeNode(context: BlogPostContext.shortSnippet)
    }
    
    if let twitterHandle = drop.config["twitter", "siteHandle"]?.string {
        parameters["site_twitter_handle"] = twitterHandle.makeNode()
    }
    
    return try drop.view.make("index", parameters)
}

drop.get("about") { req in
    
    var parameters = [
        "aboutPage": true.makeNode(),
        "uri": req.uri.description.makeNode()
    ]
    
    if let twitterHandle = drop.config["twitter", "siteHandle"]?.string {
        parameters["site_twitter_handle"] = twitterHandle.makeNode()
    }
    
    return try drop.view.make("about", parameters)
}


drop.run()

