import UIKit

enum ChatFactory {
    static func make(dto: ChatDTO) -> UIViewController {
        let service = ChatService()
        let router = ChatRouter()
        let presenter = ChatPresenter(router: router)
        let interactor = ChatInteractor(service: service, presenter: presenter)
        let viewController = ChatViewController(interactor: interactor, dto: dto)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
