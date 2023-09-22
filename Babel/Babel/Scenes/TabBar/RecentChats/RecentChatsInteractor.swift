protocol RecentChatsInteracting: AnyObject {
    func loadSomething()
}

final class RecentChatsInteractor {
    private let service: RecentChatsServicing
    private let presenter: RecentChatsPresenting

    init(service: RecentChatsServicing, presenter: RecentChatsPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - RecentChatsInteracting
extension RecentChatsInteractor: RecentChatsInteracting {
    func loadSomething() {
        presenter.displaySomething()
    }
}
