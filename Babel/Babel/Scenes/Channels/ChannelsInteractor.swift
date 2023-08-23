protocol ChannelsInteracting: AnyObject {
    func loadSomething()
}

final class ChannelsInteractor {
    private let service: ChannelsServicing
    private let presenter: ChannelsPresenting

    init(service: ChannelsServicing, presenter: ChannelsPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - ChannelsInteracting
extension ChannelsInteractor: ChannelsInteracting {
    func loadSomething() {
        presenter.displaySomething()
    }
}
