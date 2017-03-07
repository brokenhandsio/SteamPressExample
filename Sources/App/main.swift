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
var cspConfig = "default-src 'none'; script-src 'self' https://platform.twitter.com https://ajax.googleapis.com/ https://cdnjs.cloudflare.com/ https://maxcdn.bootstrapcdn.com/ https://\(disqusName).disqus.com/ https://a.disquscdn.com/; style-src 'self' https://maxcdn.bootstrapcdn.com/ https://a.disquscdn.com/ https://cdnjs.cloudflare.com/ajax/libs/select2/; img-src 'self' data: https://referrer.disqus.com/ https://a.disquscdn.com/; connect-src 'self' https://links.services.disqus.com/; child-src https://disqus.com/ https://platform.twitter.com; form-action 'self'; base-uri 'self'; require-sri-for script style;"

if let reportUri = drop.config["csp", "report-uri"]?.string {
    cspConfig += " report-uri \(reportUri);"
}

if drop.environment == .production || drop.environment == .test {
    cspConfig += " upgrade-insecure-requests; block-all-mixed-content;"
}

let referrerPolicy = ReferrerPolicyConfiguration(.strictOriginWhenCrossOrigin)

let securityHeaders = SecurityHeaders(contentSecurityPolicyConfiguration: ContentSecurityPolicyConfiguration(value: cspConfig), referrerPolicyConfiguration: referrerPolicy)
drop.middleware.append(securityHeaders)

try drop.addProvider(SteamPress.Provider.self)

drop.get { req in
    var posts = try BlogPost.query().sort("created", .descending).limit(3).all()
    
    var parameters: [String: Node] = [:]
    
    if posts.count > 0 {
        parameters["posts"] = try posts.makeNode(context: BlogPostContext.shortSnippet)
    }
    
    return try drop.view.make("index", parameters)
}

drop.get("about") { req in
    return try drop.view.make("about", ["aboutPage": true])
}


drop.run()

