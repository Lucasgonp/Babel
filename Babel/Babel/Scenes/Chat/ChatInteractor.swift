protocol ChatInteracting: AnyObject {
    func loadSomething()
}

final class ChatInteractor {
    private let service: ChatServicing
    private let presenter: ChatPresenting

    init(service: ChatServicing, presenter: ChatPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - ChatInteracting
extension ChatInteractor: ChatInteracting {
    func loadSomething() {
        presenter.displaySomething()
    }
}
