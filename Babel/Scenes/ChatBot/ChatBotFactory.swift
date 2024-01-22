import UIKit

enum ChatBotFactory {
    static func make(dto: ChatBotDTO) -> UIViewController {
        let messageWorker = ChatBotMessageWorker()
        let openAIWorker = ChatBotAIWorker()
        let router = ChatBotRouter()
        let presenter = ChatBotPresenter(router: router)
        let interactor = ChatBotInteractor(presenter: presenter, dto: dto, messageWorker: messageWorker, openAIWorker: openAIWorker)
        let viewController = ChatBotViewController(interactor: interactor, dto: dto)
        
        router.viewController = viewController
        presenter.viewController = viewController
        
        let viewModel = ChatBotViewModel()
        interactor.viewModel = viewModel
        viewController.viewModel = viewModel

        return viewController
    }
}
