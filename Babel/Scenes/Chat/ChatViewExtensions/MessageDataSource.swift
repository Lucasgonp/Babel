import MessageKit
import DesignKit
import UIKit

extension ChatViewController: MessagesDataSource {
    var currentSender: SenderType { mkSender }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return mkMessages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mkMessages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if shouldDisplayHeader(for: message, at: indexPath) {
            let shouldLoadMore = indexPath.section == 0 && (dto.allLocalMessages?.count ?? 0) > dto.displayingMessagesCount
            let text = shouldLoadMore ? Strings.ChatView.pullToLoad.localized() : MessageKitDateFormatter.shared.string(from: message.sentDate)
            let font = shouldLoadMore ? Font.Verdana.demiBold.font(size: .sm) : Font.Verdana.demiBold.font(size: .xs)
            let color = shouldLoadMore ? UIColor.systemBlue : UIColor.white
            
            return NSAttributedString(
                string: text,
                attributes: [
                    .strokeWidth: -3.0,
                    .strokeColor: Color.primary900.uiColor,
                    .font: font,
                    .foregroundColor: color
                ]
            )
        }
        
        return nil
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(
            string: message.sentDate.time(),
            attributes: [
                .strokeWidth: -3.0,
                .strokeColor: Color.greyScaleStatic800,
                .foregroundColor: Color.greyScaleStatic200,
                .font: Font.Verdana.demiBold.font(size: .xs)
            ]
        )
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isFromCurrentSender(message: message) {
            let message = mkMessages[indexPath.section]
            let status = ChatMessageStatus(rawValue: message.status)!.localized
            
            if indexPath.section == mkMessages.count - 1 {
                return NSAttributedString(
                    string: status,
                    attributes: [
                        .strokeWidth: -3.0,
                        .strokeColor: Color.greyScaleStatic800,
                        .foregroundColor: Color.greyScaleStatic200,
                        .font: Font.Verdana.demiBold.font(size: .xs)
                    ]
                )
            }
        }
        
        return nil
    }
    
    // TODO: messageTimestampLabelAttributedText
}
