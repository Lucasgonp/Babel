import NetworkKit
import UIKit
import Authenticator

enum HomeFactory {
    static func make() -> UIViewController {
        let authManager = AuthManager.shared
        let authPresentation = AuthenticatorPresentation.shared
        let service = HomeService(client: NetworkManager.session, authManager: authManager)
        let router = HomeRouter(authPresentation: authPresentation)
        let presenter = HomePresenter(router: router)
        let interactor = HomeInteractor(service: service, presenter: presenter)
        let viewController = HomeViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
