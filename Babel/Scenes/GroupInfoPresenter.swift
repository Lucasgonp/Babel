import UIKit

protocol GroupInfoPresenting: AnyObject {
    func displayGroup(with groupInfo: Group, members: [User])
    func updateGroupInfo(dto: EditGroupDTO)
    func updateGroupDesc(_ description: String)
    func displayLoading(isLoading: Bool)
    func displayError(message: String)
    func didNextStep(action: GroupInfoAction)
}

final class GroupInfoPresenter {
    private let router: GroupInfoRouting
    weak var viewController: GroupInfoDisplaying?

    init(router: GroupInfoRouting) {
        self.router = router
    }
}

extension GroupInfoPresenter: GroupInfoPresenting {
    func displayGroup(with groupInfo: Group, members: [User]) {
        viewController?.displayViewState(.success(groupInfo: groupInfo, members: members))
    }
    
    func updateGroupInfo(dto: EditGroupDTO) {
        viewController?.displayViewState(.updateInfo(dto))
    }
    
    func updateGroupDesc(_ description: String) {
        viewController?.displayViewState(.updateDesc(description))
    }
    
    func displayLoading(isLoading: Bool) {
        viewController?.displayViewState(.setLoading(isLoading: isLoading))
    }
    
    func displayError(message: String) {
        viewController?.displayViewState(.error(message: message))
    }
    
    func didNextStep(action: GroupInfoAction) {
        router.perform(action: action)
    }
}
