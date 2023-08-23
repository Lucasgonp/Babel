import Authenticator

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
    
    init(
        service: SettingsServicing,
        presenter: SettingsPresenting
    ) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - SettingsInteracting
extension SettingsInteractor: SettingsInteracting {
    func loadSettings() {
        service.checkAuthentication { [weak self] credentials in
            if let credentials, credentials.firebaseUser.isEmailVerified {
                self?.presenter.displayViewState(.success(user: credentials.user))
            } else {
                self?.presenter.didNextStep(action: .logout)
            }
        }
    }
    
    func editProfile() {
        guard let user = AccountInfo.shared.credentials?.user else {
            return
        }
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
