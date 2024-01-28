import FirebaseFirestoreSwift
import Foundation

struct Group: Codable, Equatable {
    let id: String
    var name: String
    var description: String
    var avatarLink: String
    var membersIds: [String]
    var adminIds: [String]
    var removedMembersIds: [String] = []
    var requestToJoinMemberIds: [String] = []
    @ServerTimestamp var createdDate = Date()
}
