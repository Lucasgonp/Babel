import UIKit
import FirebaseStorage
import ProgressHUD

extension StorageAdapter {
    public func downloadVideo(_ link: String, completion: @escaping (_ isReadyToPlay: Bool,_ videoFileName: String, _ fileDirectory: String) -> Void) {
        let videoUrl = URL(string: link)!
        let videoFileName = fileNameFrom(fileUrl: link) + ".mov"
        let fileDirectory = fileInDocumentsDirectory(fileName: videoFileName)
        
        if fileExistsAtPath(path: videoFileName) {
            completion(true, videoFileName, fileDirectory)
        } else {
            URLSession.shared.dataTask(with: videoUrl) { [weak self] (data, response, error) in
                if let error = error {
                    fatalError("couldn't convert local video: \(error.localizedDescription)")
                }
                
                if let data {
                    self?.saveFileLocally(fileData: data, fileName: videoFileName)
                    
                    DispatchQueue.main.async {
                        completion(true, videoFileName, fileDirectory)
                    }
                }
            }.resume()
        }
    }
}
