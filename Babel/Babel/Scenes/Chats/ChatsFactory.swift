import UIKit

enum ChatsFactory {
    static func make() -> UIViewController {
        let service = ChatsService()
        let router = ChatsRouter()
        let presenter = ChatsPresenter(router: router)
        let interactor = ChatsInteractor(service: service, presenter: presenter)
        let viewController = ChatsViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
