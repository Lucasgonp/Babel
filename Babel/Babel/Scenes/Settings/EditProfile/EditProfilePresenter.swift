protocol EditProfilePresenting: AnyObject {
    func displaySomething()
    func didNextStep(action: EditProfileAction)
}

final class EditProfilePresenter {
    private let router: EditProfileRouting
    weak var viewController: EditProfileDisplaying?

    init(router: EditProfileRouting) {
        self.router = router
    }
}

// MARK: - EditProfilePresenting
extension EditProfilePresenter: EditProfilePresenting {
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep(action: EditProfileAction) {
        router.perform(action: action)
    }
}
