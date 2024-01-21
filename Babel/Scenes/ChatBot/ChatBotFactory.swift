import UIKit

enum ChatBotFactory {
    static func make(dto: ChatBotDTO) -> UIViewController {
        let worker = ChatBotWorker()
        let router = ChatBotRouter()
        let presenter = ChatBotPresenter(router: router)
        let interactor = ChatBotInteractor(worker: worker, presenter: presenter, dto: dto)
        let viewController = ChatBotViewController(interactor: interactor, dto: dto)
        
        router.viewController = viewController
        presenter.viewController = viewController
        
        let viewModel = ChatBotViewModel()
        interactor.viewModel = viewModel
        viewController.viewModel = viewModel

        return viewController
    }
}
