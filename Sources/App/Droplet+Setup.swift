import Vapor
import SteamPress

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

            if let twitterHandle = self.config["twitter", "siteHandle"]?.string {
                parameters["site_twitter_handle"] = twitterHandle
            }

            return try self.view.make("index", parameters)
        }

        self.get("about") { req in

            var parameters: [String: NodeRepresentable] = [
                "about_page": true,
                "uri": req.uri.description
            ]

            if let twitterHandle = self.config["twitter", "siteHandle"]?.string {
                parameters["site_twitter_handle"] = twitterHandle
            }

            return try self.view.make("about", parameters)
        }
    }

}
