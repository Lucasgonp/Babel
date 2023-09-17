import Foundation
import typealias Dependencies.ServerTimestampAdapter

struct RecentChat: Codable {
    let id: String
    var chatRoomId: String
    
    let senderId: String
    let senderName: String
    
    let receiverId: String
    let receiverName: String
    
    @ServerTimestampAdapter var date = Date()
    
    let membersId: [String]
    
    let lastMassage: String
    let unreadCounter: Int
    
    let avatarLink: String
}
