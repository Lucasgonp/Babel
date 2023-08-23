protocol SettingsInteracting: AnyObject {
    func loadSettings()
    func editProfile()
    func tellAFriend()
    func termsAndConditions()
    func logout()
}

final class SettingsInteractor {
    private let service: SettingsServicing
    private let presenter: SettingsPresenting
    private let user: User
    
    init(
        service: SettingsServicing,
        presenter: SettingsPresenting,
        user: User
    ) {
        self.service = service
        self.presenter = presenter
        self.user = user
    }
}

// MARK: - SettingsInteracting
extension SettingsInteractor: SettingsInteracting {
    func loadSettings() {
        presenter.displayViewState(.success(user: user))
    }
    
    func editProfile() {
        presenter.didNextStep(action: .pushEditProfile(user: user))
    }
    
    func tellAFriend() {
        presenter.didNextStep(action: .pushTellAFriend)
    }
    
    func termsAndConditions() {
        presenter.didNextStep(action: .pushTermsAndCondition)
    }
    
    func logout() {
        presenter.didNextStep(action: .logout)
    }
}

private extension SettingsInteractor {
    func showLoading() {
        presenter.displayViewState(.loading(isLoading: true))
    }
    
    func hideLoading() {
        presenter.displayViewState(.loading(isLoading: false))
    }
}
