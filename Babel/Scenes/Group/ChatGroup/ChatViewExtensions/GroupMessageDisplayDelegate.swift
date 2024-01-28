import UIKit
import MessageKit
import DesignKit

extension ChatGroupViewController: MessagesDisplayDelegate {
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
            imageView.setImage(with: imageURL, placeholderImage: Image.photoPlaceholder.image) { image in
                let mediaItem = PhotoMessage(path: imageURL.absoluteString, image: image)
                self.mkMessages[indexPath.section].kind = .photo(mediaItem)
            }
        }
        
        if case .video = message.kind {
            let mkMessage = mkMessages[indexPath.section]
            let videoMessage = mkMessage.videoItem
            imageView.setImage(with: videoMessage?.thumbailUrl) { image in
                imageView.image = image
            }
            
            StorageManager.shared.downloadVideo(mkMessage.videoItem!.url!) { [weak self] isReadyToPlay, videoFileName, fileDirectory in
                let videoUrl: URL
                if #available(iOS 16.0, *) {
                    videoUrl = URL(filePath: fileDirectory)
                } else {
                    videoUrl = URL(fileURLWithPath: fileDirectory)
                }
                
                let videoItem = VideoMessage(url: videoUrl, thumbailUrl: videoMessage!.thumbailUrl)
                self?.mkMessages[indexPath.section].kind = .video(videoItem)
            }
        }
        
        if case .audio = message.kind {
            let mkMessage = mkMessages[indexPath.section]
            let audioItem = mkMessage.audioItem
            
            StorageManager.shared.downloadAudio(mkMessage.audioItem!.url.absoluteString) { [weak self] audioFileUrl in
                let audioUrl: URL
                if #available(iOS 16.0, *) {
                    audioUrl = URL(filePath: audioFileUrl)
                } else {
                    audioUrl = URL(fileURLWithPath: audioFileUrl)
                }
                
                let audioMessage = AudioMessage(url: audioUrl, duration: Float(audioItem!.duration))
                self?.mkMessages[indexPath.section].kind = .audio(audioMessage)
            }
        }
    }
}
