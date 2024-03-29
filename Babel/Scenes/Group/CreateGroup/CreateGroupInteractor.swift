import UIKit
import DesignKit

protocol CreateGroupInteractorProtocol: AnyObject {
    func loadAllUsers()
    func createGroup(_ group: CreateGroupDTO)
}

final class CreateGroupInteractor {
    private let worker: CreateGroupWorkerProtocol
    private let presenter: CreateGroupPresenterProtocol
    
    private var currentUser: User {
        UserSafe.shared.user
    }

    init(worker: CreateGroupWorkerProtocol, presenter: CreateGroupPresenterProtocol) {
        self.worker = worker
        self.presenter = presenter
    }
}

extension CreateGroupInteractor: CreateGroupInteractorProtocol {
    func loadAllUsers() {
        worker.getAllUsers { [weak self] result in
            switch result {
            case let .success(users):
                self?.presenter.displayAllUsers(users)
            case let .failure(error):
                fatalError("error: \(error.localizedDescription)")
            }
        }
    }
    
    func createGroup(_ dto: CreateGroupDTO) {
        presenter.setLoading(isLoading: true)
        uploadImage(dto.avatarImage) { [weak self] avatarLink in
            guard let self else { return }
            let group = Group(
                id: dto.id,
                name: dto.name,
                description: dto.description ?? String(),
                avatarLink: avatarLink ?? String(),
                membersIds: dto.members.compactMap({ $0.id }),
                adminIds: [self.currentUser.id]
            )
            self.worker.addGroup(group) { error in
                self.presenter.setLoading(isLoading: false)
                if let error {
                    self.presenter.displayErrorMessage(message: error.localizedDescription)
                } else {
                    self.presenter.didNextStep(action: .finishGroupCreation)
                }
            }
        }
    }
}

private extension CreateGroupInteractor {
    func uploadImage(_ image: UIImage, completion: @escaping (_ avatarLink: String?) -> Void) {
        if image == Image.avatarPlaceholder.image {
            return completion(nil)
        }
        
        let directory = FileDirectory.avatars.format(currentUser.id)
        worker.uploadAvatarImage(image, directory: directory, completion: completion)
    }
}
