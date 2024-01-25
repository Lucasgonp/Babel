import DesignKit
import MessageKit

struct MKSender: SenderType, Equatable {
    var senderId: String
    var displayName: String
    var avatarLink: String
}

enum MessageDefaults {
    static let bubbleColorIncomingColor = Color.ChatView.incomingBubble.uiColor
    static let bubbleColorOutgoingColor = Color.ChatView.outgoingBubble.uiColor
}

enum ChatMessageType: String {
    case text
    case audio
    case photo
    case video
    case location
}

enum ChatMessageStatus: String {
    case send
    case sent
    case read
    
    var localized: String {
        switch self {
        case .send:
            return Strings.ChatView.send.localized()
        case .sent:
            return Strings.ChatView.sent.localized()
        case .read:
            return Strings.ChatView.read.localized()
        }
    }
}

enum RecentChatType: String, Codable {
    case chat
    case group
}
