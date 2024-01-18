protocol SettingsPresenterProtocol: AnyObject {
    func displayViewState(_ state: SettingsViewState)
    func didNextStep(action: SettingsAction)
}

final class SettingsPresenter {
    private let router: SettingsRouterProtocol
    weak var viewController: SettingsDisplaying?

    init(router: SettingsRouterProtocol) {
        self.router = router
    }
}

// MARK: - SettingsPresenterProtocol
extension SettingsPresenter: SettingsPresenterProtocol {
    func displayViewState(_ state: SettingsViewState) {
        viewController?.displayViewState(state)
    }
    
    func didNextStep(action: SettingsAction) {
        router.perform(action: action)
    }
}
