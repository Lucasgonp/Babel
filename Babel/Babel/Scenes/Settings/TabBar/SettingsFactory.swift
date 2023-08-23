import UIKit
import Authenticator

enum SettingsFactory {
    static func make(delegate: HomeViewDelegate) -> UIViewController {
        let authManager = AuthManager.shared
        let service = SettingsService(authManager: authManager)
        let router = SettingsRouter()
        let presenter = SettingsPresenter(router: router)
        let interactor = SettingsInteractor(service: service, presenter: presenter)
        let viewController = SettingsViewController(interactor: interactor)

        router.delegate = delegate
        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
