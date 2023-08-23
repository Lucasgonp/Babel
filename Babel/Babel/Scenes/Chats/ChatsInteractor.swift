protocol ChatsInteracting: AnyObject {
    func loadSomething()
}

final class ChatsInteractor {
    private let service: ChatsServicing
    private let presenter: ChatsPresenting

    init(service: ChatsServicing, presenter: ChatsPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - ChatsInteracting
extension ChatsInteractor: ChatsInteracting {
    func loadSomething() {
        presenter.displaySomething()
    }
}
