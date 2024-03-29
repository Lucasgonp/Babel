import UIKit

enum RegisterFactory {
    static func make() -> UIViewController {
        let authManager = AuthManager.shared
        let service = RegisterWorker(authWorker: authManager)
        let router = RegisterRouter()
        let presenter = RegisterPresenter(router: router)
        let interactor = RegisterInteractor(service: service, presenter: presenter)
        let viewController = RegisterViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
