protocol SystemSettingsPresenterProtocol: AnyObject {
    func displaySomething()
    func didNextStep(action: SystemSettingsAction)
}

final class SystemSettingsPresenter {
    private let router: SystemSettingsRouterProtocol
    weak var viewController: SystemSettingsDisplaying?

    init(router: SystemSettingsRouterProtocol) {
        self.router = router
    }
}

extension SystemSettingsPresenter: SystemSettingsPresenterProtocol {
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep(action: SystemSettingsAction) {
        router.perform(action: action)
    }
}
