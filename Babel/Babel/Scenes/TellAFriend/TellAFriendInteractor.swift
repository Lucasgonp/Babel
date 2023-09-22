protocol TellAFriendInteracting: AnyObject {
    func loadSomething()
}

final class TellAFriendInteractor {
    private let service: TellAFriendServicing
    private let presenter: TellAFriendPresenting

    init(service: TellAFriendServicing, presenter: TellAFriendPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - TellAFriendInteracting
extension TellAFriendInteractor: TellAFriendInteracting {
    func loadSomething() {
        presenter.displaySomething()
    }
}
