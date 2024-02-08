import Authenticator

protocol SettingsInteractorProtocol: AnyObject {
    func loadSettings()
    func editProfile()
    func chatsSettings()
    func tellAFriend()
    func termsAndConditions()
    func systemSettings()
    func logout()
}

final class SettingsInteractor {
    private let service: SettingsWorkerProtocol
    private let presenter: SettingsPresenterProtocol
    private var user: User
    
    private var currentUser: User {
        getCurrentUser()
    }
    
    init(
        service: SettingsWorkerProtocol,
        presenter: SettingsPresenterProtocol,
        user: User
    ) {
        self.service = service
        self.presenter = presenter
        self.user = user
    }
}

// MARK: - SettingsInteractorProtocol
extension SettingsInteractor: SettingsInteractorProtocol {
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
    
    func chatsSettings() {
        presenter.didNextStep(action: .pushChatsSettings)
    }
    
    func tellAFriend() {
        presenter.didNextStep(action: .pushTellAFriend)
    }
    
    func termsAndConditions() {
        presenter.didNextStep(action: .pushTermsAndCondition)
    }
    
    func systemSettings() {
        presenter.didNextStep(action: .pushSystemSettings)
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
