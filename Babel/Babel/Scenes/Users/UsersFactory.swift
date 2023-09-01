import UIKit
import NetworkKit

enum UsersFactory {
    static func make() -> UIViewController {
        let firebaseClient = FirebaseClient.shared
        let service = UsersService(firebaseClient: firebaseClient)
        let router = UsersRouter()
        let presenter = UsersPresenter(router: router)
        let interactor = UsersInteractor(service: service, presenter: presenter)
        let viewController = UsersViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
