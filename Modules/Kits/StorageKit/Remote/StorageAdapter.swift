import FirebaseStorage

public final class StorageAdapter {
    public static let shared = StorageAdapter()
    
    let storage: Storage
    let fileManager: FileManager
    
    private init(storage: Storage = Storage.storage(), fileManager: FileManager = .default) {
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
        let directoryPath = fileInDocumentsDirectory(fileName: String())
        
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: directoryPath)
            for file in contents {
                let filePath = directoryPath.appending(file)
                try fileManager.removeItem(atPath: filePath)
            }
        } catch {
            print("Error deleting files: \(error)")
        }
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
