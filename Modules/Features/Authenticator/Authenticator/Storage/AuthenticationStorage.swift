import StorageKit

public struct AuthenticationStorage {
    public static func saveUserLocally(_ user: User) {
        AccountInfo.shared.user = user
        StorageLocal.shared.saveStorageData(user, key: .currentUser)
    }
}
