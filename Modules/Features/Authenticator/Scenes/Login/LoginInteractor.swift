protocol LoginInteractorProtocol: AnyObject {
    func loginWith(userModel: LoginUserRequestModel)
    func resendEmailVerification()
    func didTapOnForgotPassword()
    func resetPassword(email: String)
    func signUpAction()
}

final class LoginInteractor {
    private let service: LoginWorkerProtocol
    private let presenter: LoginPresenterProtocol
    
    init(service: LoginWorkerProtocol, presenter: LoginPresenterProtocol) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - LoginInteractorProtocol
extension LoginInteractor: LoginInteractorProtocol {
    func loginWith(userModel: LoginUserRequestModel) {
        showButtonLoading()
        service.login(userRequest: userModel) { [weak self] result in
            guard let self else {
                return
            }
            self.hideButtonLoading()
            switch result {
            case .success(let model):
                if model.isEmailVerified {
                    self.presenter.didNextStep(action: .didLoginSuccess)
                } else {
                    self.presenter.displayResendEmailAlert()
                }
            case .failure(let error):
                self.presenter.displayViewState(.error(message: error.localizedDescription))
            }
        }
    }
    
    func resendEmailVerification() {
        showHudLoading()
        service.resendEmailVerification { [weak self] error in
            guard let self else {
                return
            }
            self.hideHudLoading()
            if let error {
                self.presenter.displayViewState(.error(message: error.localizedDescription))
            } else {
                self.presenter.displayResentEmailFeedback()
            }
        }
    }
    
    func didTapOnForgotPassword() {
        presenter.displayForgotPasswordAlert()
    }
    
    func resetPassword(email: String) {
        showHudLoading()
        service.resetPassword(email: email) { [weak self] error in
            guard let self else {
                return
            }
            self.hideHudLoading()
            if let error {
                self.presenter.displayViewState(.error(message: error.localizedDescription))
            } else {
                self.presenter.displayResetPasswordFeedback()
            }
        }
    }
    
    func signUpAction() {
        presenter.didNextStep(action: .presentSignUp)
    }
}

private extension LoginInteractor {
    func showButtonLoading() {
        presenter.displayViewState(.loadingButton(isLoading: true))
    }
    
    func hideButtonLoading() {
        presenter.displayViewState(.loadingButton(isLoading: false))
    }
    
    func showHudLoading() {
        presenter.displayViewState(.loadingHud(isLoading: true))
    }
    
    func hideHudLoading() {
        presenter.displayViewState(.loadingHud(isLoading: false))
    }
}
