import Vapor
import Fluent
import Sessions
import SteamPress
import Foundation
import VaporPostgreSQL

let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider.self)

let memory = MemorySessions()
let sessions = SessionsMiddleware(sessions: memory)
drop.middleware.append(sessions)

let steamPress = SteamPress(drop: drop, blogPath: "blog")

drop.get { req in
    drop.log.error("An Admin user been created for you - the username is admin and the password is password")

    var posts = try BlogPost.all()
    posts.sort { $0.created > $1.created }
    let newPosts = posts.prefix(3)
    
    var parameters: [String: Node] = [:]
    
    if newPosts.count > 0 {
        var postsNode = [Node]()
        for post in newPosts {
            postsNode.append(try post.makeNodeWithExtras())
        }
        parameters["posts"] = try postsNode.makeNode()
    }
    
    return try drop.view.make("index", parameters)
}

drop.get("about") { req in
    return try drop.view.make("about", ["aboutPage": true])
}


drop.run()
