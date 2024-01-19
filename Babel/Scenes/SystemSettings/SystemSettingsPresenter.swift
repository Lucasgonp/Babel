protocol SystemSettingsPresenting: AnyObject {
    func displaySomething()
    func didNextStep(action: SystemSettingsAction)
}

final class SystemSettingsPresenter {
    private let router: SystemSettingsRouting
    weak var viewController: SystemSettingsDisplaying?

    init(router: SystemSettingsRouting) {
        self.router = router
    }
}

extension SystemSettingsPresenter: SystemSettingsPresenting {
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep(action: SystemSettingsAction) {
        router.perform(action: action)
    }
}
