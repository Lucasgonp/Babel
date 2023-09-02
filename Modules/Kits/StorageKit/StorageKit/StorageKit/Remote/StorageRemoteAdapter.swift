import FirebaseStorage

public final class StorageRemoteAdapter {
    let storage: Storage
    let fileManager: FileManager
    
    public init(storage: Storage = Storage.storage(), fileManager: FileManager = .default) {
        self.storage = storage
        self.fileManager = fileManager
    }
}
