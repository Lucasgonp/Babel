import Foundation
import typealias Dependencies.ServerTimestampAdapter

struct RecentChatModel: Codable, Equatable {
    let id: String
    var chatRoomId: String
    
    let senderId: String
    let senderName: String
    
    let receiverId: String
    let receiverName: String
    
    @ServerTimestampAdapter var date = Date()
    
    let membersId: [String]
    
    var lastMassage: String
    var unreadCounter: Int
    
    let avatarLink: String
}
