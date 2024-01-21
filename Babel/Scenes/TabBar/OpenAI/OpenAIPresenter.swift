protocol OpenAIPresenterProtocol: AnyObject {
    func displaySomething()
    func didNextStep(action: OpenAIAction)
}

final class OpenAIPresenter {
    private let router: OpenAIRouterProtocol
    weak var viewController: OpenAIDisplaying?

    init(router: OpenAIRouterProtocol) {
        self.router = router
    }
}

extension OpenAIPresenter: OpenAIPresenterProtocol {
    func displaySomething() {
        viewController?.displaySomething()
    }
    
    func didNextStep(action: OpenAIAction) {
        router.perform(action: action)
    }
}
