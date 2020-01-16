import Vapor
import SteampressFluentPostgres
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let authSessions = router.grouped(BlogAuthSessionsMiddleware())
    
    authSessions.get { req -> Future<View> in
        return BlogPost.query(on: req).filter(\.published == true).sort(\.created, .descending).range(0..<3).all().flatMap { posts in
            let disqusName = Environment.get("BLOG_DISQUS_NAME")
            let siteTwitterHandle = Environment.get("BLOG_SITE_TWITTER_HANDLE")
            let googleAnalyticsIdentifier = Environment.get("BLOG_GOOGLE_ANALYTICS_IDENTIFIER")
            let loggedInUser = try req.authenticated(BlogUser.self)
            let webpageURL = req.http.url.absoluteString
            let postsWithShortSnippets = posts.map { $0.toPostWithShortSnippet() }
            let context = HomepageContext(posts: postsWithShortSnippets, user: loggedInUser, twitterHandler: siteTwitterHandle, googleAnalytics: googleAnalyticsIdentifier, disqusName: disqusName, webpageURL: webpageURL)
            return try req.view().render("index", context)
        }
    }
    
    authSessions.get("about") { req -> Future<View> in
        let disqusName = Environment.get("BLOG_DISQUS_NAME")
        let siteTwitterHandle = Environment.get("BLOG_SITE_TWITTER_HANDLE")
        let googleAnalyticsIdentifier = Environment.get("BLOG_GOOGLE_ANALYTICS_IDENTIFIER")
        let loggedInUser = try req.authenticated(BlogUser.self)
        let webpageURL = req.http.url.absoluteString
        let context = AboutPageContext(webpageURL: webpageURL, user: loggedInUser, twitterHandler: siteTwitterHandle, googleAnalytics: googleAnalyticsIdentifier, disqusName: disqusName)
        return try req.view().render("about", context)
    }
}

struct HomepageContext: Encodable {
    let posts: [PostWithShortSnippet]
    let user: BlogUser?
    let twitterHandler: String?
    let googleAnalytics: String?
    let disqusName: String?
    let webpageURL: String
}

struct AboutPageContext: Encodable {
    let aboutPage = true
    let webpageURL: String
    let user: BlogUser?
    let twitterHandler: String?
    let googleAnalytics: String?
    let disqusName: String?
}
