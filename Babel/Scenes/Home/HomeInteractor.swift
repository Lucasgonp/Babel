import Foundation

protocol HomeInteractorProtocol: AnyObject {
    func checkAuthentication()
    func performLogout()
}

final class HomeInteractor {
    private let service: HomeWorkerProtocol
    private let presenter: HomePresenterProtocol
    
    init(service: HomeWorkerProtocol, presenter: HomePresenterProtocol) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - HomeInteractorProtocol
extension HomeInteractor: HomeInteractorProtocol {
    func checkAuthentication() {
        showLoading()
        service.checkAuthentication { [weak self] authCredentials in
            self?.hideLoading()
            if let authCredentials, authCredentials.firebaseUser.isEmailVerified {
                self?.presenter.displayViewState(.success(user: authCredentials.user))
            } else {
                self?.presenter.didNextStep(action: .presentLogin)
            }
        }
    }
    
    func performLogout() {
        showLoading()
        service.logout { [weak self] error in
            self?.hideLoading()
            if let error {
                self?.presenter.displayViewState(.error(message: error.localizedDescription))
            } else {
                self?.presenter.didNextStep(action: .presentLogin)
            }
        }
    }
}

private extension HomeInteractor {
    func showLoading() {
        presenter.displayViewState(.loading(isLoading: true))
    }
    
    func hideLoading() {
        presenter.displayViewState(.loading(isLoading: false))
    }
}
