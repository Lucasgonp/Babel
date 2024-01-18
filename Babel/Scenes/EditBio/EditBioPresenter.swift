protocol EditBioPresenterProtocol: AnyObject {
    func displayErrorMessage(message: String)
    func didNextStep(action: EditBioAction)
}

final class EditBioPresenter {
    private let router: EditBioRouterProtocol
    weak var viewController: EditBioDisplaying?

    init(router: EditBioRouterProtocol) {
        self.router = router
    }
}

// MARK: - EditBioPresenterProtocol
extension EditBioPresenter: EditBioPresenterProtocol {
    func displayErrorMessage(message: String) {
        viewController?.displayErrorMessage(message: message)
    }
    
    func didNextStep(action: EditBioAction) {
        router.perform(action: action)
    }
}
