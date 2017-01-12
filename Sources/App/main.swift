import Vapor
import Fluent
import Sessions
import SteamPress
import Foundation

let drop = Droplet()

let database = Database(MemoryDriver())
drop.database = database

let memory = MemorySessions()
let sessions = SessionsMiddleware(sessions: memory)
drop.middleware.append(sessions)

let steamPress = SteamPress(drop: drop, blogPath: "blog")

drop.get { req in
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
