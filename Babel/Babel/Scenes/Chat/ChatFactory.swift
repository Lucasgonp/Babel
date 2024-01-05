import UIKit

enum ChatFactory {
    static func make(dto: ChatDTO) -> UIViewController {
        let router = ChatRouter()
        let presenter = ChatPresenter(router: router)
        let interactor = ChatInteractor(presenter: presenter, dto: dto)
        let viewController = ChatViewController(interactor: interactor, dto: dto)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
