protocol OpenAIInteractorProtocol: AnyObject {
    func loadSomething()
}

final class OpenAIInteractor {
    private let worker: OpenAIWorker
    private let presenter: OpenAIPresenterProtocol

    init(worker: OpenAIWorker, presenter: OpenAIPresenterProtocol) {
        self.worker = worker
        self.presenter = presenter
    }
}

extension OpenAIInteractor: OpenAIInteractorProtocol {
    func loadSomething() {
        presenter.displaySomething()
    }
}
