import UIKit

enum GroupInfoFactory {
    static func make(groupId: String, delegate: GroupInfoUpdateProtocol? = nil) -> UIViewController {
        let worker = GroupInfoWorker()
        let router = GroupInfoRouter()
        let presenter = GroupInfoPresenter(router: router)
        let interactor = GroupInfoInteractor(worker: worker, presenter: presenter, groupId: groupId)
        let viewController = GroupInfoViewController(interactor: interactor)
        
        viewController.delegate = delegate
        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
