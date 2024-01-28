import UIKit

enum ChatGroupFactory {
    static func make(dto: ChatGroupDTO) -> UIViewController {
        let router = ChatGroupRouter()
        let presenter = ChatGroupPresenter(router: router)
        let interactor = ChatGroupInteractor(presenter: presenter, dto: dto)
        let viewController = ChatGroupViewController(interactor: interactor, dto: dto)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
