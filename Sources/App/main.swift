import Vapor
import Fluent
import Sessions
import SteamPress
import Foundation
import VaporPostgreSQL

let drop = Droplet()
//let database = Database(MemoryDriver())
//drop.database = database
try drop.addProvider(VaporPostgreSQL.Provider.self)

let memory = MemorySessions()
let sessions = SessionsMiddleware(sessions: memory)
drop.middleware.append(sessions)

// Temporary!
(drop.view as? LeafRenderer)?.stem.cache = nil

let steamPress = SteamPress(drop: drop, blogPath: "blog")

drop.get { req in
    var posts = try BlogPost.all()
    posts.sort { $0.created > $1.created }
    // Todo the query should be able to sort by date and get the latest 3 - will be much more efficient
    let newPosts = posts.prefix(3)
    
    var parameters: [String: Node] = [:]
    
    if newPosts.count > 0 {
        parameters["posts"] = try newPosts.makeNode(context: BlogPostShortSnippet())
    }
    
    return try drop.view.make("index", parameters)
}

drop.get("about") { req in
    return try drop.view.make("about", ["aboutPage": true])
}


drop.run()
