import StorageKit

struct StorageManager {
    static let shared = StorageAdapter()
    
    private init() {}
}
