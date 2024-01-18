protocol TellAFriendInteractorProtocol: AnyObject {
    func loadSomething()
}

final class TellAFriendInteractor {
    private let service: TellAFriendWorkerProtocol
    private let presenter: TellAFriendPresenterProtocol

    init(service: TellAFriendWorkerProtocol, presenter: TellAFriendPresenterProtocol) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - TellAFriendInteractorProtocol
extension TellAFriendInteractor: TellAFriendInteractorProtocol {
    func loadSomething() {
        presenter.displaySomething()
    }
}
