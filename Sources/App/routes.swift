import Vapor
import SteampressFluentPostgres
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let authSessions = router.grouped(BlogAuthSessionsMiddleware())
    
    authSessions.get { req -> Future<View> in
        return BlogPost.query(on: req).filter(\.published == true).sort(\.created, .descending).range(0..<3).all().flatMap { posts in
            let pageInformation = try req.getPageInformation()
            let postsWithShortSnippets = posts.map { $0.toPostWithShortSnippet() }
            let context = HomepageContext(posts: postsWithShortSnippets, pageInformation: pageInformation)
            return try req.view().render("index", context)
        }
    }
    
    authSessions.get("about") { req -> Future<View> in
        let pageInformation = try req.getPageInformation()
        let context = AboutPageContext(pageInformation: pageInformation)
        return try req.view().render("about", context)
    }
}

struct HomepageContext: Encodable {
    let posts: [PostWithShortSnippet]
    let pageInformation: PageInformation
}

struct AboutPageContext: Encodable {
    let aboutPage = true
    let pageInformation: PageInformation
}

struct PageInformation: Encodable {
    let loggedInUser: BlogUser?
    let twitterHandler: String?
    let googleAnalytics: String?
    let disqusName: String?
    let webpageURL: String
}

extension Request {
    func getPageInformation() throws -> PageInformation {
        let disqusName = Environment.get("BLOG_DISQUS_NAME")
        let siteTwitterHandle = Environment.get("BLOG_SITE_TWITTER_HANDLE")
        let googleAnalyticsIdentifier = Environment.get("BLOG_GOOGLE_ANALYTICS_IDENTIFIER")
        let loggedInUser = try self.authenticated(BlogUser.self)
        let webpageURL = self.http.url.absoluteString
        return PageInformation(loggedInUser: loggedInUser, twitterHandler: siteTwitterHandle, googleAnalytics: googleAnalyticsIdentifier, disqusName: disqusName, webpageURL: webpageURL)
    }
}
