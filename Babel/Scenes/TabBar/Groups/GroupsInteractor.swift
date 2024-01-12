protocol GroupsInteracting: AnyObject {
    func fetchAllGroups()
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
    func fetchAllGroups() {
        worker.fetchAllGroups { [weak self] result in
            switch result {
            case let .success(groups):
                self?.presenter.displayAllGroups(groups)
            case let .failure(error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func didTapCreateNewGroup() {
        presenter.didNextStep(action: .pushCreateNewGroup)
    }
}
