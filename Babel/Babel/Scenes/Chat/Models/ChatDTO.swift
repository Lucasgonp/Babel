import RealmSwift

final class ChatDTO {
    var chatId = String()
    var recipientId = String()
    var recipientName = String()
    var recipientAvatarURL = String()
    
    var allLocalMessages: Results<LocalMessage>?
    var displayingMessagesCount = 0
    var maxMessageNumber = 0
    var minMessageNumber = 0
    
    init(
        chatId: String,
        recipientId: String,
        recipientName: String,
        recipientAvatarURL: String
    ) {
        self.chatId = chatId
        self.recipientId = recipientId
        self.recipientName = recipientName
        self.recipientAvatarURL = recipientAvatarURL
    }
}
