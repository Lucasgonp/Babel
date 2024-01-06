import UIKit
import MessageKit
import CoreLocation
import struct GalleryKit.MediaVideo

final class MKMessage: NSObject, MessageType {
    var messageId: String
    var kind: MessageKind
    var sentDate: Date
    var incoming: Bool
    let mkSender: MKSender
    var sender: SenderType { mkSender }
    var photoItem: PhotoMessage?
    var videoItem: VideoMessage?
    let senderInitials: String
    var status: String
    var readDate: Date
    
    init(message: LocalMessage) {
        self.messageId = message.id
        self.mkSender = MKSender(senderId: message.senderId, displayName: message.senderName)
        self.status = message.status
        self.kind = .text(message.message)
        self.senderInitials = message.senderInitials
        self.sentDate = message.date
        self.readDate = message.readDate
        self.incoming = AccountInfo.shared.user?.id == mkSender.senderId
    }
}

extension MKMessage {
    func setup(from message: LocalMessage) {
        switch ChatMessageType(rawValue: message.type) {
        case .text:
            self.kind = .text(message.message)
        case .photo:
            let photoItem = PhotoMessage(path: message.pictureUrl)
            self.kind = .photo(photoItem)
            self.photoItem = photoItem
        case .video:
            let videoItem = VideoMessage(url: URL(string: message.videoUrl), thumbailUrl: message.pictureUrl)
            self.kind = MessageKind.video(videoItem)
            self.videoItem = videoItem
        default:
            fatalError("unkown message type")
        }
    }
}
