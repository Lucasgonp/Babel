import StorageKit

struct StorageManager {
    static let shared = StorageRemoteAdapter()
    
    private init() {}
}
