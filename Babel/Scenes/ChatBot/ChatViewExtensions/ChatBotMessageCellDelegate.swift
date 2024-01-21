import MessageKit
import AVFoundation
import AVKit
import SKPhotoBrowser

extension ChatBotViewController: MessageCellDelegate {
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
}
