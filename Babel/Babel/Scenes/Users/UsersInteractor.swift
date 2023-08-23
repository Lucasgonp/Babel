protocol UsersInteracting: AnyObject {
    func loadSomething()
}

final class UsersInteractor {
    private let service: UsersServicing
    private let presenter: UsersPresenting

    init(service: UsersServicing, presenter: UsersPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - UsersInteracting
extension UsersInteractor: UsersInteracting {
    func loadSomething() {
        presenter.displaySomething()
    }
}
