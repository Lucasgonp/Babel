import UIKit
import Authenticator

enum SettingsFactory {
    static func make(delegate: HomeViewDelegate, for user: User) -> UIViewController {
        let service = SettingsService()
        let router = SettingsRouter()
        let presenter = SettingsPresenter(router: router)
        let interactor = SettingsInteractor(service: service, presenter: presenter, user: user)
        let viewController = SettingsViewController(interactor: interactor)

        router.viewController = viewController
        router.delegate = delegate
        presenter.viewController = viewController

        return viewController
    }
}
