protocol TermsInteractorProtocol: AnyObject {
    func loadSomething()
}

final class TermsInteractor {
    private let service: TermsWorkerProtocol
    private let presenter: TermsPresenterProtocol

    init(service: TermsWorkerProtocol, presenter: TermsPresenterProtocol) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - TermsInteractorProtocol
extension TermsInteractor: TermsInteractorProtocol {
    func loadSomething() {
        presenter.displaySomething()
    }
}
