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
    private var user: User
    
    private var currentUser: User {
        getCurrentUser()
    }
    
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
        presenter.displayViewState(.success(user: currentUser))
        service.checkAuthentication { [weak self] credentials in
            if let credentials, credentials.firebaseUser.isEmailVerified {
                if self?.currentUser != credentials.user {
                    self?.user = credentials.user
                    self?.presenter.displayViewState(.success(user: credentials.user))
                }
            } else {
                self?.presenter.didNextStep(action: .logout)
            }
        }
    }
    
    func editProfile() {
        presenter.didNextStep(action: .pushEditProfile(user: currentUser))
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
    
    func getCurrentUser() -> User {
        return AccountInfo.shared.user ?? user
    }
}
