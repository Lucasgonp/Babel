import Foundation

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

extension TellAFriendInteractor: TellAFriendInteractorProtocol {
    func fetchContacts() {
        DispatchQueue.global().async {
            PhoneContacts.shared.requestAccess { [weak self] accessGranted in
                if accessGranted {
                    let allContacts = PhoneContacts.shared.fetchContacts()
                    self?.presenter.displayContacts(allContacts)
                } else {
                    self?.presenter.contactsAccessNotGranted()
                }
            }
        }
    }
}
