import Foundation
import MessageKit
import UIKit

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
    
//    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        var visibleRect = CGRect()
//        
//        visibleRect.origin = self.messagesCollectionView.contentOffset
//        visibleRect.size = self.messagesCollectionView.bounds.size
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//        
//        guard let indexPath = self.messagesCollectionView.indexPathForItem(at: visiblePoint) else { return }
//        
//        print(" \(indexPath)")
//        if indexPath.section == 3 {
//            
//        }
//    }
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
