protocol RegisterInteracting: AnyObject {
    func loadSomething()
}

final class RegisterInteractor {
    private let service: RegisterServicing
    private let presenter: RegisterPresenting

    init(service: RegisterServicing, presenter: RegisterPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - RegisterInteracting
extension RegisterInteractor: RegisterInteracting {
    func loadSomething() {
        presenter.displaySomething()
    }
}
