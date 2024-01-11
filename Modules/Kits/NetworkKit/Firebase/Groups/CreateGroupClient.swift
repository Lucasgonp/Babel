import class FirebaseFirestore.QuerySnapshot
import StorageKit

public protocol CreateGroupClientProtocol {
    func createGroup(dto: StartGroupDTO, completion: @escaping (Error?) -> Void)
    func saveRecent<T: Codable>(id: String, recentChat: T)
}

extension FirebaseClient: CreateGroupClientProtocol {
    public func createGroup(dto: StartGroupDTO, completion: @escaping (Error?) -> Void) {
        StorageLocal.shared.saveStorageData(dto, key: .group)
        
        do {
            try firebaseReference(.group).document(dto.id).setData(from: dto, completion: { error in
                completion(error)
            })
        } catch {
            completion(error)
        }
    }
}

private extension FirebaseClient {
    func removeMemberWhoHasRecent(snapshot: QuerySnapshot, memberIds: [String], storageKey: String) -> [String] {
        var membersIdsToCreateRecent = memberIds
        for recentData in snapshot.documents {
            let currentRecent = recentData.data() as Dictionary
            if let currentUserId = currentRecent[storageKey] as? String {
                if membersIdsToCreateRecent.contains(currentUserId) {
                    membersIdsToCreateRecent.remove(at: membersIdsToCreateRecent.firstIndex(of: currentUserId)!)
                }
            }
        }
        return membersIdsToCreateRecent
    }
}

