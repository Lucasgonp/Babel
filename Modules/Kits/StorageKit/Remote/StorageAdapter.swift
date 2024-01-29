import FirebaseStorage
import Kingfisher

public final class StorageAdapter {
    let storage: Storage
    let fileManager: FileManager
    
    public init(storage: Storage = Storage.storage(), fileManager: FileManager = .default) {
        self.storage = storage
        self.fileManager = fileManager
    }
    
    public func fileExistsAtPath(path: String) -> Bool {
        fileManager.fileExists(atPath: fileInDocumentsDirectory(fileName: path))
    }
    
    public func getDocumentsURL() -> URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).last!
    }
    
    public func clearCache() {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
}

extension StorageAdapter {
    func fileInDocumentsDirectory(fileName: String) -> String {
        getDocumentsURL().appendingPathComponent(fileName).path
    }
    
    func fileNameFrom(fileUrl: String) -> String {
        ((fileUrl.components(separatedBy: "_").last)!.components(separatedBy: "?").first!).components(separatedBy: ".").first!
    }
}
