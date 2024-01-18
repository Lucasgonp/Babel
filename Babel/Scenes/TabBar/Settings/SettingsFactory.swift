import UIKit

enum SettingsFactory {
    static func make(delegate: HomeViewDelegate, user: User) -> UIViewController {
        let authManager = AuthManager.shared
        let service = SettingsWorker(authManager: authManager)
        let router = SettingsRouter()
        let presenter = SettingsPresenter(router: router)
        let interactor = SettingsInteractor(service: service, presenter: presenter, user: user)
        let viewController = SettingsViewController(interactor: interactor)
        
        router.delegate = delegate
        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
