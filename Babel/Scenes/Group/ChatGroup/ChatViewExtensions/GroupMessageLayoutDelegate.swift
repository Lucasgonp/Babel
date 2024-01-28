import MessageKit
import SDWebImage

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
        // TIP: If you want to show all avatar just remove this method
//        removeStatusMessageSpace()
        
        if isFromCurrentSender(message: message) {
            return (indexPath.section == mkMessages.count - 1) ? 16 : .zero
        }
        
        return .zero
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 14
    }
    
    //TIP: If you want to show all avatars just remove this method
//    func messageBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment? {
//        if isFromCurrentSender(message: message) {
//            return LabelAlignment(textAlignment: .right, textInsets: .init(top: .zero, left: .zero, bottom: .zero, right: 6))
//        } else {
//            return LabelAlignment(textAlignment: .left, textInsets: .init(top: .zero, left: 6, bottom: .zero, right: .zero))
//        }
//    }
    
    //TIP: If you want to show all avatars just use avatarView.set(avatar: Avatar(initials: mkMessages[indexPath.section].senderInitials))
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.set(avatar: Avatar(initials: mkMessages[indexPath.section].senderInitials))
        
//        guard avatarView.image == nil else { return }
        
//        guard let url = URL(string: mkMessages[indexPath.section].mkSender.avatarLink) else {
//            avatarView.set(avatar: Avatar(initials: mkMessages[indexPath.section].senderInitials))
//            return
//        }
//        DispatchQueue.global().async {
//            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
//                StorageManager.shared.saveFileLocally(fileData: data!, fileName: url.absoluteString)
//                DispatchQueue.main.async {
//                    avatarView.set(avatar: Avatar(image: UIImage(data: data!)))
//                }
//            }).resume()
//        }
//        avatarView.isHidden = true
    }
    
    //TIP: If you want to show all avatars just remove this method
//    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize? {
//        return .zero
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
