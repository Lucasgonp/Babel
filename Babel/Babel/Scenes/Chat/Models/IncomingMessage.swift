import MessageKit
import CoreLocation

final class IncomingMessage {
    let messagesViewController: MessagesViewController
    
    init(messagesViewController: MessagesViewController) {
        self.messagesViewController = messagesViewController
    }
    
    func createMessage(localMessage: LocalMessage) -> MKMessage? {
        let mkMessage = MKMessage(message: localMessage)
        return mkMessage
    }
}
