import MessageKit
import AVFoundation
import AVKit
import SKPhotoBrowser

extension ChatGroupViewController: MessageCellDelegate {
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
              let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
            return
        }
        
        if case let .photo(item) = message.kind {
            var images = [SKPhoto]()
            let photo = SKPhoto.photoWithImage(item.image!)
            images.append(photo)
            
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(0)
            
            present(browser, animated: true, completion: nil)
        }
        
        if case let .video(item) = message.kind {
            let player = AVPlayer(url: item.url!)
            let moviePlayer = AVPlayerViewController()
            
            try? AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            
            moviePlayer.player = player
            
            present(moviePlayer, animated: true) {
                moviePlayer.player!.play()
            }
        }
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        
        let mkMessage = mkMessages[indexPath.section]
        if let locationItem = mkMessage.locationItem {
            let mapView = MapViewController(location: locationItem.location, userName: mkMessage.sender.displayName)
            
            navigationController?.pushViewController(mapView, animated: true)
        }
    }
    
    func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                print("Failed to identify message when audio cell receive tap gesture")
                return
        }
        
        guard audioController.state != .stopped else {
            audioController.playSound(for: message, in: cell)
            return
        }
        
        if audioController.playingMessage?.messageId == message.messageId {
            if audioController.state == .playing {
                audioController.pauseSound(for: message, in: cell)
            } else {
                audioController.resumeSound()
            }
        } else {
            audioController.stopAnyOngoingPlaying()
            audioController.playSound(for: message, in: cell)
        }
    }
}
