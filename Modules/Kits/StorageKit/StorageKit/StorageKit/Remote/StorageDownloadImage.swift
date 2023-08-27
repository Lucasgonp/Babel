import UIKit

public protocol StorageDownloadImageProtocol {
    func downloadImage(imageUrl: String, completion: @escaping (UIImage?) -> Void)
}

extension StorageRemoteAdapter: StorageDownloadImageProtocol {
    public func downloadImage(imageUrl: String, completion: @escaping (UIImage?) -> Void) {
        let imageFileName = fileNameFrom(fileUrl: imageUrl)
        if fileExistsAtPath(path: imageFileName) {
            if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentsDirectory(fileName: imageFileName)) {
                completion(contentsOfFile)
            } else {
                fatalError("Could't convert local image")
            }
        } else {
            if let documentUrl = URL(string: imageUrl), !imageUrl.isEmpty {
                let downloadQueue = DispatchQueue(label: "ImageDownloadQueue")
                downloadQueue.async { [weak self] in
                    if let data = NSData(contentsOf: documentUrl) {
                        self?.saveFileLocally(fileData: data, fileName: imageFileName)
                        DispatchQueue.main.async {
                            print("downloaded image")
                            completion(UIImage(data: data as Data))
                        }
                    } else {
                        print("No document in database")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
}
