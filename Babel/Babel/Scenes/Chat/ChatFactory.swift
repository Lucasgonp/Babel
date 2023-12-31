import UIKit
import NetworkKit

enum ChatFactory {
    static func make(dto: ChatDTO) -> UIViewController {
        let service = ChatService(client: FirebaseClient.shared)
        let router = ChatRouter()
        let presenter = ChatPresenter(router: router)
        let interactor = ChatInteractor(service: service, presenter: presenter, dto: dto)
        let viewController = ChatViewController(interactor: interactor, dto: dto)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
