import StorageKit

public struct AuthenticationStorage {
    public static func saveUserLocally(_ user: User) {
        StorageLocal.shared.saveStorageData(user, key: .currentUser)
    }
}
