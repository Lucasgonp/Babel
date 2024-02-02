import StorageKit

struct StorageManager {
    static let shared = StorageAdapter.shared
    
    private init() {}
}
