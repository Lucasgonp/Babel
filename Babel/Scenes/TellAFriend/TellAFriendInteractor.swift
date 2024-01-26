protocol TellAFriendInteractorProtocol: AnyObject {
    func fetchContacts()
}

final class TellAFriendInteractor {
    private let service: TellAFriendWorkerProtocol
    private let presenter: TellAFriendPresenterProtocol

    init(service: TellAFriendWorkerProtocol, presenter: TellAFriendPresenterProtocol) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - TellAFriendInteractorProtocol
extension TellAFriendInteractor: TellAFriendInteractorProtocol {
    func fetchContacts() {
        PhoneContacts.requestAccess { [weak self] accessGranted in
            if accessGranted {
                let allContacts = PhoneContacts.fetchContacts()
                self?.presenter.displayContacts(allContacts)
            } else {
                self?.presenter.contactsAccessNotGranted()
            }
        }
    }
}
