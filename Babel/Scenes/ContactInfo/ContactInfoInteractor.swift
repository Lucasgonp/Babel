protocol ContactInfoInteractorProtocol: AnyObject {
    func loadContactInfo()
    func startChat()
}

final class ContactInfoInteractor {
    private let service: ContactInfoWorkerProtocol
    private let presenter: ContactInfoPresenterProtocol
    private let currentUser = UserSafe.shared.user
    
    private var contactUser: User?
    private let contactUserId: String
    private let shouldDisplayStartChat: Bool

    init(
        service: ContactInfoWorkerProtocol,
        presenter: ContactInfoPresenterProtocol,
        contactUser: User? = nil,
        contactUserId: String = String(),
        shouldDisplayStartChat: Bool
    ) {
        self.service = service
        self.presenter = presenter
        self.contactUser = contactUser
        self.contactUserId = contactUserId
        self.shouldDisplayStartChat = shouldDisplayStartChat
    }
}

// MARK: - ContactInfoInteractorProtocol
extension ContactInfoInteractor: ContactInfoInteractorProtocol {
    func loadContactInfo() {
        if let contactUser {
            presenter.displayViewState(.success(contact: contactUser, shouldDisplayStartChat: shouldDisplayStartChat))
        } else {
            presenter.displayViewState(.setLoading(isLoading: true))
            service.getContactUser(from: contactUserId) { [weak self] result in
                guard let self else { return }
                
                self.presenter.displayViewState(.setLoading(isLoading: false))
                
                switch result {
                case let .success(user):
                    self.contactUser = user
                    self.presenter.displayViewState(.success(contact: user, shouldDisplayStartChat: self.shouldDisplayStartChat))
                case let .failure(error):
                    // TODO: Present error message
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
    
    func startChat() {
        guard let contactUser else { return }
        
        let chatId = StartChat.shared.startChat(user1: currentUser, user2: contactUser)
        let chatDTO = ChatDTO(chatId: chatId, recipientId: contactUser.id, recipientName: contactUser.name, recipientAvatarURL: contactUser.avatarLink)
        presenter.didNextStep(action: .pushChatView(dto: chatDTO))
    }
}
