import MessageKit
import DesignKit
import UIKit

extension ChatGroupViewController: MessagesDataSource {
    var currentSender: SenderType { mkSender }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return mkMessages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mkMessages.count
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let text = mkMessages[indexPath.section].mkSender.displayName
        let font = Font.sm.make(isBold: true)
        let color = UIColor.darkGray
        
        return NSAttributedString(
            string: text,
            attributes: [.font: font, .foregroundColor: color]
        )
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if shouldDisplayHeader(for: message, at: indexPath) {
            let shouldLoadMore = indexPath.section == 0 && (dto.allLocalMessages?.count ?? 0) > dto.displayingMessagesCount
            let text = shouldLoadMore ? Localizable.pullToLoad : MessageKitDateFormatter.shared.string(from: message.sentDate)
            let font = shouldLoadMore ? Font.sm.make(isBold: true) : Font.xs.make(isBold: true)
            let color = shouldLoadMore ? UIColor.systemBlue : UIColor.darkGray
            
            return NSAttributedString(
                string: text,
                attributes: [.font: font, .foregroundColor: color]
            )
        }
        
        return nil
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let font = Font.xs.make(isBold: true)
        return NSAttributedString(
            string: message.sentDate.time(),
            attributes: [.font: font, .foregroundColor: UIColor.darkGray]
        )
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isFromCurrentSender(message: message) {
            let message = mkMessages[indexPath.section]
            if indexPath.section == mkMessages.count - 1 {
                return NSAttributedString(
                    string: message.status,
                    attributes: [
                        .font: Font.xs.make(isBold: true),
                        .foregroundColor: UIColor.darkGray
                    ]
                )
            }
        }
        
        return nil
    }
    
    // TODO: messageTimestampLabelAttributedText
}
