import UIKit
import FirebaseStorage
import ProgressHUD

public final class StorageRemoteAdapter {
    let storage: Storage
    let fileManager: FileManager
    
    public init(storage: Storage = Storage.storage(), fileManager: FileManager = .default) {
        self.storage = storage
        self.fileManager = fileManager
    }
}

extension StorageRemoteAdapter {
    func getDocumentsUrl() -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).last ?? URL(fileURLWithPath: String())
    }
    
    func fileInDocumentsDirectory(fileName: String) -> String {
        return getDocumentsUrl().appending(path: fileName).path()
    }
    
    func fileExistsAtPath(path: String) -> Bool {
        let filePath = fileInDocumentsDirectory(fileName: path)
        return fileManager.fileExists(atPath: filePath)
    }
}

extension StorageRemoteAdapter {
    func fileNameFrom(fileUrl: String) -> String {
        let fileName = fileUrl
            .components(separatedBy: "_").last?
            .components(separatedBy: "?").first?
            .components(separatedBy: ".").first
        return fileName ?? String()
    }
}
