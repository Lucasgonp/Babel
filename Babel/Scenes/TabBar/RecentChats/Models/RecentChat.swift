import Foundation
import FirebaseFirestoreSwift

struct RecentChatModel: Codable, Equatable {
    let id: String
    var chatRoomId: String
    
    let senderId: String
    let senderName: String
    
    let receiverId: String
    var receiverName: String
    
    @ServerTimestamp var date = Date()
    
    var membersId: [String]
    
    var lastMassage: String
    var unreadCounter: Int
    
    var avatarLink: String
    
    // group or chat
    let groupName: String?
    let type: RecentChatType?
}
