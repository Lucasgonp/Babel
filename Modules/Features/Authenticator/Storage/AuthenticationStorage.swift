import StorageKit

public struct AuthenticationStorage {
    public static func saveUserLocally(_ user: User) {
        var user = user
        user.password = String()
        StorageLocal.shared.saveStorageData(user, key: .currentUser)
    }
}
