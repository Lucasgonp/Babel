import UIKit

enum RequestsJoinGroupFactory {
    static func make(requestsIds: [String], groupId: String) -> UIViewController {
        let worker = RequestsJoinGroupWorker()
        let router = RequestsJoinGroupRouter()
        let presenter = RequestsJoinGroupPresenter(router: router)
        let interactor = RequestsJoinGroupInteractor(worker: worker, presenter: presenter, usersIds: requestsIds, groupId: groupId)
        let viewController = RequestsJoinGroupViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
