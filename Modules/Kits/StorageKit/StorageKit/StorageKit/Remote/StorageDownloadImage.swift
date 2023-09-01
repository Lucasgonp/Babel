import UIKit

public protocol StorageDownloadImageProtocol {
    func downloadImage(imageUrl: String, completion: @escaping (UIImage?) -> Void)
}

extension StorageRemoteAdapter: StorageDownloadImageProtocol {
    public func downloadImage(imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageFileName = fileNameFrom(fileUrl: imageUrl) else {
            DispatchQueue.main.async { completion(nil) }
            return
        }
        
        
        if fileExistsAtPath(path: imageFileName) {
            if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(fileName: imageFileName)) {
                DispatchQueue.main.async { completion(contentsOfFile) }
            } else {
                fatalError("Could't convert local image")
            }
        } else {
            guard let documentUrl = URL(string: imageUrl) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            DispatchQueue.global().async { [weak self] in
                if let data = NSData(contentsOf: documentUrl) {
                    self?.saveFileLocally(fileData: data, fileName: imageFileName)
                    let image = UIImage(data: data as Data)
                    DispatchQueue.main.async { completion(image) }
                } else {
                    DispatchQueue.main.async { completion(nil) }
                }
            }
        }
    }
}
