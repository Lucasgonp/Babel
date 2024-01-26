import Contacts

protocol TellAFriendPresenterProtocol: AnyObject {
    func displayContacts(_ contacts: [CNContact])
    func contactsAccessNotGranted()
    func didNextStep(action: TellAFriendAction)
}

final class TellAFriendPresenter {
    private let router: TellAFriendRouterProtocol
    weak var viewController: TellAFriendDisplaying?

    init(router: TellAFriendRouterProtocol) {
        self.router = router
    }
}

// MARK: - TellAFriendPresenterProtocol
extension TellAFriendPresenter: TellAFriendPresenterProtocol {
    func displayContacts(_ contacts: [CNContact]) {
        viewController?.displayViewState(.success(contacts: contacts))
    }
    
    func contactsAccessNotGranted() {
        viewController?.displayViewState(.accessNotGranted(message: ""))
    }
    
    func didNextStep(action: TellAFriendAction) {
        router.perform(action: action)
    }
}
