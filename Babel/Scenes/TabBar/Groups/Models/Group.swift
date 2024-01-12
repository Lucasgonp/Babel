import FirebaseFirestoreSwift
import Foundation

struct Group: Codable {
    let id: String
    let name: String
    let description: String
    let avatarLink: String
    let memberIds: [String]
    let adminId: String
    @ServerTimestamp var createdDate = Date()
}

//struct Group: Codable {
//    let id: String
//    let name: String
//    let adminId: String
//    let memberIds: [String]
//    let status: String
//    let avatarLink: String
//    @ServerTimestamp var createdDate = Date()
//    @ServerTimestamp var lastMessageDate = Date()
//    
//    enum CodingKeys: String, CodingKeys {
//        case id, name, adminId, memberIds, status, avatarLink, createdDate
//        case lastMessageDate = "date"
//    }
//}
