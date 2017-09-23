import Vapor
import SteamPress
import AuthProvider

extension Droplet {
    public func setup() throws {
        self.get { req in
            let posts = try BlogPost.makeQuery()
                .filter(BlogPost.Properties.published, true)
                .sort(BlogPost.Properties.created, .descending)
                .limit(3).all()

            var parameters: [String: NodeRepresentable] = [
                "uri": req.uri.description
            ]

            if posts.count > 0 {
                parameters["posts"] = try posts.makeNode(in: BlogPostContext.shortSnippet)
            }
            
            if req.auth.isAuthenticated(BlogUser.self) {
                parameters["user"] = try req.auth.assertAuthenticated(BlogUser.self)
            }

            if let twitterHandle = self.config["twitter", "siteHandle"]?.string {
                parameters["site_twitter_handle"] = twitterHandle
            }
            
            if let twitterHandle = self.config["twitter", "siteHandle"]?.string {
                parameters["site_twitter_handle"] = twitterHandle
            }
            
            if let gaIdentifier = self.config["googleAnalytics", "identifier"]?.string {
                parameters["google_analytics_identifier"] = gaIdentifier
            }

            return try self.view.make("index", parameters)
        }

        self.get("about") { req in

            var parameters: [String: NodeRepresentable] = [
                "about_page": true,
                "uri": req.uri.description
            ]
            
            if req.auth.isAuthenticated(BlogUser.self) {
                parameters["user"] = try req.auth.assertAuthenticated(BlogUser.self)
            }

            if let twitterHandle = self.config["twitter", "siteHandle"]?.string {
                parameters["site_twitter_handle"] = twitterHandle
            }
            if let gaIdentifier = self.config["googleAnalytics", "identifier"]?.string {
                parameters["google_analytics_identifier"] = gaIdentifier
            }

            return try self.view.make("about", parameters)
        }
        
        self.get("abort") { req in
            throw Abort.serverError
            
        }
    }

}
