import UIKit

struct OutgoingMessage: Encodable {
    let chatId: String
    let text: String?
    let photo: Data?
    let video: String?
    let audio: String?
    let audioDuration: Float?
    let location: String?
    let memberIds: [String]
    
    init(
        chatId: String,
        text: String? = nil,
        photo: UIImage? = nil,
        video: String? = nil,
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

/*
 import UIKit

 struct OngoingMessage {
     let chatId: String
     let value: Any
     let audioDuration: Float?
     
     init(chatId: String, value: Any, audioDuration: Float? = nil) {
         self.chatId = chatId
         self.value = value
         self.audioDuration = audioDuration
     }
 }

 enum OutgoingMessageType {
     case text(chatId: String, text: String)
     case audio(chatId: String, audio: String, audioDuration: Float)
     case photo(chatId: String, photo: UIImage)
     case video(chatId: String, video: String)
     case location(chatId: String, location: String)
     
     var message: OngoingMessage {
         switch self {
         case let .text(chatId, text):
             return OngoingMessage(chatId: chatId, value: text)
         case let .audio(chatId, audio, audioDuration):
             return OngoingMessage(chatId: chatId, value: audio, audioDuration: audioDuration)
         case let .photo(chatId, photo):
             return OngoingMessage(chatId: chatId, value: photo)
         case let .video(chatId, video):
             return OngoingMessage(chatId: chatId, value: video)
         case let .location(chatId, location):
             return OngoingMessage(chatId: chatId, value: location)
         }
     }
 }

 //struct OutgoingMessage: Encodable {
 //    let chatId: String
 //    let text: String?
 //    let photo: Data?
 //    let video: String?
 //    let audio: String?
 //    let audioDuration: Float?
 //    let location: String?
 //    let memberIds: [String]
 //
 //    init(
 //        chatId: String,
 //        text: String? = nil,
 //        photo: UIImage? = nil,
 //        video: String? = nil,
 //        audio: String? = nil,
 //        audioDuration: Float? = nil,
 //        location: String? = nil,
 //        memberIds: [String] = []
 //    ) {
 //        self.chatId = chatId
 //        self.text = text
 //        self.photo = photo?.pngData()
 //        self.video = video
 //        self.audio = audio
 //        self.audioDuration = audioDuration
 //        self.location = location
 //        self.memberIds = memberIds
 //    }
 //}

 
 */
