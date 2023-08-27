protocol EditBioPresenting: AnyObject {
    func displayErrorMessage(message: String)
    func didNextStep(action: EditBioAction)
}

final class EditBioPresenter {
    private let router: EditBioRouting
    weak var viewController: EditBioDisplaying?

    init(router: EditBioRouting) {
        self.router = router
    }
}

// MARK: - EditBioPresenting
extension EditBioPresenter: EditBioPresenting {
    func displayErrorMessage(message: String) {
        viewController?.displayErrorMessage(message: message)
    }
    
    func didNextStep(action: EditBioAction) {
        router.perform(action: action)
    }
}
