protocol LoginInteracting: AnyObject {
    func loginWith(userModel: LoginUserModel)
    func signUpAction()
}

final class LoginInteractor {
    private let service: LoginServicing
    private let presenter: LoginPresenting

    init(service: LoginServicing, presenter: LoginPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - LoginInteracting
extension LoginInteractor: LoginInteracting {
    func loginWith(userModel: LoginUserModel) {
        showLoading()
        service.login(userRequest: userModel) { [weak self] result in
            guard let self else {
                return
            }
            self.hideLoading()
            switch result {
            case .success:
                self.presenter.didNextStep(action: .didLoginSuccess)
            case .failure(let error):
                self.presenter.displayViewState(.error(message: error.localizedDescription))
            }
        }
    }
    
    func signUpAction() {
        presenter.didNextStep(action: .presentSignUp)
    }
}

private extension LoginInteractor {
    func showLoading() {
        presenter.displayViewState(.loading(isLoading: true))
    }
    
    func hideLoading() {
        presenter.displayViewState(.loading(isLoading: false))
    }
}
