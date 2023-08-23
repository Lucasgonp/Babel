protocol SettingsPresenting: AnyObject {
    func displayViewState(_ state: SettingsViewState)
    func didNextStep(action: SettingsAction)
}

final class SettingsPresenter {
    private let router: SettingsRouting
    weak var viewController: SettingsDisplaying?

    init(router: SettingsRouting) {
        self.router = router
    }
}

// MARK: - SettingsPresenting
extension SettingsPresenter: SettingsPresenting {
    func displayViewState(_ state: SettingsViewState) {
        viewController?.displayViewState(state)
    }
    
    func didNextStep(action: SettingsAction) {
        router.perform(action: action)
    }
}
