import Foundation
import MessageKit

extension ChatGroupViewController: MessagesLayoutDelegate {    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if shouldDisplayHeader(for: message, at: indexPath) {
            if indexPath.section == 0 && (dto.allLocalMessages?.count ?? 0) > dto.displayingMessagesCount {
                return 40
            }
            return 24
        }
        return .zero
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 24
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isFromCurrentSender(message: message) {
            return (indexPath.section == mkMessages.count - 1) ? 16 : .zero
        }
        
        return .zero
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 14
    }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.set(avatar: Avatar(initials: mkMessages[indexPath.section].senderInitials))
    }
}

private extension ChatGroupViewController {
    func removeStatusMessageSpace() {
        let flowLayout = messagesCollectionView.messagesCollectionViewFlowLayout
        flowLayout.setMessageIncomingCellBottomLabelAlignment(
            LabelAlignment(textAlignment: .left, textInsets: .init(top: .zero, left: 6, bottom: .zero, right: .zero))
        )
        flowLayout.setMessageOutgoingCellBottomLabelAlignment(
            LabelAlignment(textAlignment: .right, textInsets: .init(top: .zero, left: .zero, bottom: .zero, right: 6))
        )
    }
}
