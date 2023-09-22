protocol TermsInteracting: AnyObject {
    func loadSomething()
}

final class TermsInteractor {
    private let service: TermsServicing
    private let presenter: TermsPresenting

    init(service: TermsServicing, presenter: TermsPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - TermsInteracting
extension TermsInteractor: TermsInteracting {
    func loadSomething() {
        presenter.displaySomething()
    }
}
