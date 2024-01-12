protocol GroupsInteracting: AnyObject {
    func loadAllGroups()
    func didTapCreateNewGroup()
}

final class GroupsInteractor {
    private let worker: GroupsWorkerProtocol
    private let presenter: GroupsPresenting

    init(worker: GroupsWorkerProtocol, presenter: GroupsPresenting) {
        self.worker = worker
        self.presenter = presenter
    }
}

// MARK: - GroupsInteracting
extension GroupsInteractor: GroupsInteracting {
    func loadAllGroups() {
        presenter.displaySomething()
    }
    
    func didTapCreateNewGroup() {
        presenter.didNextStep(action: .pushCreateNewGroup)
    }
}
