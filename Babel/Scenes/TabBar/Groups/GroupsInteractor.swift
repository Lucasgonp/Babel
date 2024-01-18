protocol GroupsInteractorProtocol: AnyObject {
    func fetchAllGroups()
    func didTapCreateNewGroup()
    func didTapOnGroup(id: String)
}

final class GroupsInteractor {
    private let worker: GroupsWorkerProtocol
    private let presenter: GroupsPresenterProtocol

    init(worker: GroupsWorkerProtocol, presenter: GroupsPresenterProtocol) {
        self.worker = worker
        self.presenter = presenter
    }
}

extension GroupsInteractor: GroupsInteractorProtocol {
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
    
    func didTapOnGroup(id: String) {
        presenter.didNextStep(action: .pushGroupInfo(id: id))
    }
}
