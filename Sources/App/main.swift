import Vapor
import Fluent
import Sessions
import SteamPress
import Foundation
import VaporPostgreSQL

let drop = Droplet()
let database = Database(MemoryDriver())
drop.database = database
//try drop.addProvider(VaporPostgreSQL.Provider.self)

let memory = MemorySessions()
let sessions = SessionsMiddleware(sessions: memory)
drop.middleware.append(sessions)

// Temporary!
(drop.view as? LeafRenderer)?.stem.cache = nil

let steamPress = SteamPress(drop: drop, blogPath: "blog")

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
