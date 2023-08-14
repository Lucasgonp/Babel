protocol LoginInteracting: AnyObject {
    func loadSomething()
}

final class LoginInteractor {
    private let service: LoginServicing
    private let presenter: LoginPresenting

    init(service: LoginServicing, presenter: LoginPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - LoginInteracting
extension LoginInteractor: LoginInteracting {
    func loadSomething() {
        presenter.displaySomething()
    }
}
