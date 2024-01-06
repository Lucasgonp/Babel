import UIKit
import MessageKit
import SDWebImage
import DesignKit

extension ChatViewController: MessagesDisplayDelegate {
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .label
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? MessageDefaults.bubbleColorOutgoingColor : MessageDefaults.bubbleColorIncomingColor
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let currentUserLastMessage = mkMessages.filter({ $0.sender.senderId == currentSender.senderId }).last
        let receiverUserLastMessage = mkMessages.filter({ $0.sender.senderId != currentSender.senderId }).last
        
        if mkMessages[indexPath.section] == currentUserLastMessage {
            return .bubbleTail(.bottomRight, .curved)
        }
        
        if mkMessages[indexPath.section] == receiverUserLastMessage {
            return .bubbleTail(.bottomLeft, .curved)
        }
        
        return .bubble
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if case .photo(let media) = message.kind, let imageURL = media.url {
            imageView.setImage(with: imageURL, placeholderImage: Image.photoPlaceholder.image)
        }
        
        if case let .video(videoItem) = message.kind {
            let mkMessage = mkMessages[indexPath.section]
            let videoMessage = mkMessage.videoItem
            imageView.setImage(with: videoMessage?.thumbailUrl)
        }
    }
}
