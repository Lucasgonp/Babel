protocol ContactInfoInteracting: AnyObject {
    func loadContactInfo()
    func startChat()
}

final class ContactInfoInteractor {
    private let service: ContactInfoServicing
    private let presenter: ContactInfoPresenting
    private let contactUser: User
    private var currentUser: User {
        AccountInfo.shared.user!
    }

    init(
        service: ContactInfoServicing,
        presenter: ContactInfoPresenting,
        contactUser: User
    ) {
        self.service = service
        self.presenter = presenter
        self.contactUser = contactUser
    }
}

// MARK: - ContactInfoInteracting
extension ContactInfoInteractor: ContactInfoInteracting {
    func loadContactInfo() {
        presenter.displayViewState(.success(contact: contactUser))
    }
    
    func startChat() {
        let chatId = StartChat.shared.startChat(user1: currentUser, user2: contactUser)
        let chatDTO = ChatDTO(chatId: chatId, recipientId: contactUser.id, recipientName: contactUser.name, recipientAvatarURL: contactUser.avatarLink)
        presenter.didNextStep(action: .pushChatView(dto: chatDTO))
    }
}
