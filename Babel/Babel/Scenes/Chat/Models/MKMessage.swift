import MessageKit
import CoreLocation

final class MKMessage: NSObject, MessageType {
    var messageId: String
    var kind: MessageKind
    var sentDate: Date
    var incoming: Bool
    let mkSender: MKSender
    var sender: SenderType {
        return mkSender
    }
    let senderInitials: String
    var status: String
    var readDate: Date
    
    init(message: LocalMessage) {
        self.messageId = message.id
        self.mkSender = MKSender(senderId: message.senderId, displayName: message.senderName)
        self.status = message.status
        self.kind = .text(message.message)
        self.senderInitials = message.senderInitials
        self.sentDate = message.date
        self.readDate = message.readDate
        self.incoming = AccountInfo.shared.user?.id == mkSender.senderId
    }
}
