import DesignKit
import MessageKit

struct MKSender: SenderType, Equatable {
    var senderId: String
    var displayName: String
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

enum RecentChatType: String, Codable {
    case chat
    case group
}
