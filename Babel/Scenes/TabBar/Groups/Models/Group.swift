import FirebaseFirestoreSwift
import Foundation

struct Group: Codable, Equatable {
    let id: String
    var name: String
    var description: String
    var avatarLink: String
    var members: [Member]
    var adminIds: [String]
    var removedMembers: [Member] = []
    var requestToJoinMemberIds: [String] = []
    @ServerTimestamp var createdDate = Date()
    
    struct Member: Codable, Equatable {
        let id: String
        let name: String
    }
}
