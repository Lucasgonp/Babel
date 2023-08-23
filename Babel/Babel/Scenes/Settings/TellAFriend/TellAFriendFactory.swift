import UIKit

enum TellAFriendFactory {
    static func make() -> UIViewController {
        let service = TellAFriendService()
        let router = TellAFriendRouter()
        let presenter = TellAFriendPresenter(router: router)
        let interactor = TellAFriendInteractor(service: service, presenter: presenter)
        let viewController = TellAFriendViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
