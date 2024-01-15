import Foundation
import RealmSwift

final class LocalMessage: Object, Codable {
    @objc dynamic var id = String()
    @objc dynamic var chatRoomId = String()
    @objc dynamic var date = Date()
    @objc dynamic var senderName = String()
    @objc dynamic var senderId = String()
    @objc dynamic var senderInitials = String()
    @objc dynamic var senderAvatarLink = String()
    @objc dynamic var readDate = Date()
    @objc dynamic var type = String()
    @objc dynamic var status = String()
    @objc dynamic var message = String()
    @objc dynamic var audioUrl = String()
    @objc dynamic var videoUrl = String()
    @objc dynamic var pictureUrl = String()
    @objc dynamic var latitude = Double()
    @objc dynamic var longitude = Double()
    @objc dynamic var audioDuration = Double()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
