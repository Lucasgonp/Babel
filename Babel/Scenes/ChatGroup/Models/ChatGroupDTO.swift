import RealmSwift

final class ChatGroupDTO {
    var chatId = String()
    
    var groupInfo: Group
    var membersIds = [String]()
    
    var allLocalMessages: Results<LocalMessage>?
    var displayingMessagesCount = 0
    var maxMessageNumber = 0
    var minMessageNumber = 0
    
    init(
        chatId: String,
        groupInfo: Group,
        membersIds: [String]
    ) {
        self.chatId = chatId
        self.groupInfo = groupInfo
        self.membersIds = membersIds
    }
}
