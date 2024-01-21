protocol ChatBotPresenterProtocol: AnyObject {
    func displaySomething()
    func didNextStep(action: ChatBotAction)
}

final class ChatBotPresenter {
    private let router: ChatBotRouterProtocol
    weak var viewController: ChatBotDisplaying?

    init(router: ChatBotRouterProtocol) {
        self.router = router
    }
}

extension ChatBotPresenter: ChatBotPresenterProtocol {
    func displaySomething() {
//        viewController?.displaySomething()
    }
    
    func didNextStep(action: ChatBotAction) {
        router.perform(action: action)
    }
}
