protocol HomeInteracting: AnyObject {
    func checkAuthentication()
    func performLogout()
}

final class HomeInteractor {
    private let service: HomeServicing
    private let presenter: HomePresenting

    init(service: HomeServicing, presenter: HomePresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - HomeInteracting
extension HomeInteractor: HomeInteracting {
    func checkAuthentication() {
        showLoading()
        service.checkAuthentication { [weak self] authCredentials in
            self?.hideLoading()
            if let authCredentials {
                self?.presenter.displayViewState(.success(message: authCredentials.user.displayName ?? String()))
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
