import FirebaseFirestoreSwift
import Foundation

struct Group: Codable {
    let id: String
    var name: String
    var description: String
    var avatarLink: String
    let members: [Member]
    let adminIds: [String]
    var removedMembers: [Member] = []
    @ServerTimestamp var createdDate = Date()
    
    struct Member: Codable {
        let id: String
        let name: String
        @ServerTimestamp var date = Date()
    }
}
