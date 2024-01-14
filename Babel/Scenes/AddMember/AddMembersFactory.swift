import UIKit

enum AddMembersFactory {
    static func make(groupMembers: [User], completion: (([User]) -> Void)?) -> UIViewController {
        let worker = AddMembersWorker()
        let router = AddMembersRouter()
        let presenter = AddMembersPresenter(router: router)
        let interactor = AddMembersInteractor(worker: worker, presenter: presenter)
        let viewController = AddMembersViewController(interactor: interactor, groupMembers: groupMembers)

        viewController.completion = completion
        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
