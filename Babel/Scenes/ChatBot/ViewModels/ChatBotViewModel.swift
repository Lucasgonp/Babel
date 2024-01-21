import RealmSwift

final class ChatBotViewModel {
    var allLocalMessages: Results<LocalMessage>?
    var displayingMessagesCount = 0
    var maxMessageNumber = 0
    var minMessageNumber = 0
}
