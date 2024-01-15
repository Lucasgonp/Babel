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
    var locationItem: LocationMessage?
    var audioItem: AudioMessage?
    let senderInitials: String
    var status: String
    var readDate: Date
    
    init(message: LocalMessage) {
        self.messageId = message.id
        self.mkSender = MKSender(senderId: message.senderId, displayName: message.senderName, avatarLink: message.senderAvatarLink)
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
            self.kind = .video(videoItem)
            self.videoItem = videoItem
        case .location:
            let locationItem = LocationMessage(location: CLLocation(latitude: message.latitude, longitude: message.longitude))
            self.kind = .location(locationItem)
            self.locationItem = locationItem
        case .audio:
            let url = URL(string: message.audioUrl) ?? URL(fileURLWithPath: String())
            let audioItem = AudioMessage(url: url, duration: Float(message.audioDuration))
            self.kind = .audio(audioItem)
            self.audioItem = audioItem
        default:
            fatalError("unkown message type")
        }
    }
}
