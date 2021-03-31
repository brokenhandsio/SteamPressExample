import Foundation
import SteamPress

struct PostWithShortSnippet: Codable {
    var blogID: Int?
    var title: String
    var contents: String
    var author: Int
    var created: Date
    var lastEdited: Date?
    var slugUrl: String
    var published: Bool
    var shortSnippet: String
}

extension BlogPost {
    func toPostWithShortSnippet() -> PostWithShortSnippet {
        return PostWithShortSnippet(blogID: self.blogID, title: self.title, contents: self.contents, author: self.author, created: self.created, lastEdited: self.lastEdited, slugUrl: self.slugUrl, published: self.published, shortSnippet: self.shortSnippet())
    }
}
