protocol GroupsTabInteracting: AnyObject {
    func loadSomething()
}

final class GroupsTabInteractor {
    private let service: GroupsTabServicing
    private let presenter: GroupsTabPresenting

    init(service: GroupsTabServicing, presenter: GroupsTabPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - GroupsTabInteracting
extension GroupsTabInteractor: GroupsTabInteracting {
    func loadSomething() {
        presenter.displaySomething()
    }
}
