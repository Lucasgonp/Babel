import UIKit
import struct GalleryKit.MediaVideo

struct OutgoingMessage: Encodable {
    let chatId: String
    let text: String?
    let photo: Data?
    let video: MediaVideo?
    let audio: String?
    let audioDuration: Float?
    let location: String?
    let memberIds: [String]
    
    init(
        chatId: String,
        text: String? = nil,
        photo: UIImage? = nil,
        video: MediaVideo? = nil,
        audio: String? = nil,
        audioDuration: Float? = nil,
        location: String? = nil,
        memberIds: [String] = []
    ) {
        self.chatId = chatId
        self.text = text
        self.photo = photo?.pngData()
        self.video = video
        self.audio = audio
        self.audioDuration = audioDuration
        self.location = location
        self.memberIds = memberIds
    }
}
