protocol RegisterInteractorProtocol: AnyObject {
    func registerUser(_ userRequest: RegisterUserRequestModel)
    func emailSentToNewUser()
    func backToLoginView()
}

final class RegisterInteractor {
    private let service: RegisterWorkerProtocol
    private let presenter: RegisterPresenterProtocol

    init(service: RegisterWorkerProtocol, presenter: RegisterPresenterProtocol) {
        self.service = service
        self.presenter = presenter
    }
}

extension RegisterInteractor: RegisterInteractorProtocol {
    func registerUser(_ userRequest: RegisterUserRequestModel) {
        showLoading()
        DispatchQueue.global().async { [weak self] in
            self?.service.register(userRequest: userRequest) { [weak self] error in
                DispatchQueue.main.async { [weak self] in
                    self?.hideLoading()
                    if let error {
                        self?.presenter.displayViewState(.error(message: error.errorDescription ?? String()))
                    } else {
                        self?.presenter.displayViewState(.success)
                    }
                }
            }
        }
    }
    
    func emailSentToNewUser() {
        presenter.emailSentToNewUser()
    }
    
    func backToLoginView() {
        presenter.didNextStep(action: .popToLogin)
    }
}

private extension RegisterInteractor {
    func showLoading() {
        presenter.displayViewState(.loading(isLoading: true))
    }
    
    func hideLoading() {
        presenter.displayViewState(.loading(isLoading: false))
    }
}
