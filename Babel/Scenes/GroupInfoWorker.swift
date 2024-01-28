import UIKit
import NetworkKit

protocol GroupInfoWorkerProtocol {
    func fetchGroup(from id: String, completion: @escaping (Result<Group, FirebaseError>) -> Void)
    func downloadUsers(with ids: [String], completion: @escaping ((Result<[User], FirebaseError>) -> Void))
    func updateAvatarImage(_ image: UIImage, directory: String, completion: @escaping (String?) -> Void)
    func saveGroupToFirebase(group: Group, completion: @escaping (Error?) -> Void)
    func saveGroupInRecentChats(group: Group)
    func addMembers(_ membersIds: [String], groupId: String, completion: @escaping (Error?) -> Void)
    func requestToJoin(groupId: String, completion: @escaping (Error?) -> Void)
    func removeMember(_ member: User, groupId: String, completion: @escaping (Error?) -> Void)
    func updatePrivileges(isAdmin: Bool, groupId: String, userId: String, completion: @escaping (Error?) -> Void)
    func exitGroup(groupId: String, completion: @escaping (Error?) -> Void)
    func deleteGroup(groupId: String)
    func removeListeners()
}

final class GroupInfoWorker {
    typealias ClientProtocol = GroupClientProtocol & UsersClientProtocol
    
    private var currentUser: User { UserSafe.shared.user }
    
    private let client: ClientProtocol
    
    init(client: ClientProtocol = FirebaseClient.shared) {
        self.client = client
    }
}

extension GroupInfoWorker: GroupInfoWorkerProtocol {
    func fetchGroup(from id: String, completion: @escaping (Result<Group, FirebaseError>) -> Void) {
        client.downloadGroup(id: id, completion: completion)
    }
    
    func downloadUsers(with ids: [String], completion: @escaping ((Result<[User], FirebaseError>) -> Void)) {
        client.downloadUsers(withIds: ids, completion: completion)
    }
    
    func updateAvatarImage(_ image: UIImage, directory: String, completion: @escaping (String?) -> Void) {
        StorageManager.shared.uploadImage(image, directory: directory, callbackThread: .main, completion: completion)
    }
    
    func saveGroupToFirebase(group: Group, completion: @escaping (Error?) -> Void) {
        client.updateGroupInfo(id: group.id, dto: group, completion: completion)
    }
    
    func saveGroupInRecentChats(group: Group) {
        client.updateGroupName(name: group.name, avatarLink: group.avatarLink, groupId: group.id)
    }
    
    func addMembers(_ membersIds: [String], groupId: String, completion: @escaping (Error?) -> Void) {
        client.addMembers(membersIds, groupId: groupId, completion: completion)
    }
    
    func requestToJoin(groupId: String, completion: @escaping (Error?) -> Void) {
        client.requestToJoin(currentUser.id, groupId: groupId, completion: completion)
    }
    
    func removeMember(_ member: User, groupId: String, completion: @escaping (Error?) -> Void) {
        client.removeMember(member.id, groupId: groupId, completion: completion)
    }
    
    func updatePrivileges(isAdmin: Bool, groupId: String, userId: String, completion: @escaping (Error?) -> Void) {
        client.updatePrivileges(isAdmin: isAdmin, groupId: groupId, for: userId, completion: completion)
    }
    
    func exitGroup(groupId: String, completion: @escaping (Error?) -> Void) {
        client.updatePrivileges(isAdmin: false, groupId: groupId, for: currentUser.id) { [weak self] error in
            guard let self else { return }
            if let error {
                completion(error)
            } else {
                self.client.removeMember(self.currentUser.id, groupId: groupId, completion: completion)
            }
        }
    }
    
    func deleteGroup(groupId: String) {
        client.deleteGroup(groupId: groupId)
    }
    
    func removeListeners() {
        client.removeGroupInfoListener()
    }
}
