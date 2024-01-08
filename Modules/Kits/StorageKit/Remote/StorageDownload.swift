import UIKit
import FirebaseStorage
import ProgressHUD

extension StorageAdapter {
    public func downloadVideo(_ link: String, completion: @escaping (_ isReadyToPlay: Bool,_ videoFileName: String, _ fileDirectory: String) -> Void) {
        let videoFileName = fileNameFrom(fileUrl: link) + ".mov"
        let fileDirectory = fileInDocumentsDirectory(fileName: videoFileName)
        
        if fileExistsAtPath(path: videoFileName) {
            completion(true, videoFileName, fileDirectory)
        } else {
            let videoUrl = URL(string: link)!
            //TODO: Use NetworkKit
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
    
    public func downloadVideo(_ videoUrl: URL, completion: @escaping (_ isReadyToPlay: Bool,_ videoFileName: String, _ fileDirectory: String) -> Void) {
        let videoFileName = fileNameFrom(fileUrl: videoUrl.absoluteString) + ".mov"
        let fileDirectory = fileInDocumentsDirectory(fileName: videoFileName)
        
        if fileExistsAtPath(path: videoFileName) {
            completion(true, videoFileName, fileDirectory)
        } else {
            // TODO: Use NetworkKit
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
    
    public func downloadAudio(_ link: String, completion: @escaping (_ audioFileName: String) -> Void) {
        let audioFileName = fileNameFrom(fileUrl: link) + ".m4a"
        let fileDirectory = fileInDocumentsDirectory(fileName: audioFileName)
        
        if fileExistsAtPath(path: audioFileName) {
            completion(audioFileName)
        } else {
            let url = URL(string: link)!
            // TODO: Use NetworkKit
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    fatalError("error download audio: \(error.localizedDescription)")
                }
                
                if let data {
                    self?.saveFileLocally(fileData: data, fileName: audioFileName)
                    
                    DispatchQueue.main.async {
                        completion(audioFileName)
                    }
                } else {
                    print("no audio in database")
                }
            }.resume()
        }
    }
}
