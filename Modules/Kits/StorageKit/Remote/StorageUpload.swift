import UIKit
import FirebaseStorage
import ProgressHUD

extension StorageAdapter {
    public func uploadImage(_ image: UIImage, directory: String, callbackThread: DispatchQueue = .main, completion: @escaping (_ documentLink: String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return completion(nil)
        }
        
        let reference = storage.reference(forURL: StorageKey.fileReference.rawValue).child(directory)
        var task: StorageUploadTask?
        task = reference.putData(imageData, completion: { metadata, error in
            task?.removeAllObservers()
            ProgressHUD.dismiss()
            
            if let error {
                print("error uploading image: \(error.localizedDescription)")
                return completion(nil)
            }
            
            reference.downloadURL { url, error in
                guard let downloadUrl = url else {
                    return completion(nil)
                }
                
                completion(downloadUrl.absoluteString)
            }
        })
        
//        task?.observe(StorageTaskStatus.progress, handler: { snapshot in
//            guard let snapshotProgress = snapshot.progress else {
//                return
//            }
//            let progress = snapshotProgress.completedUnitCount / snapshotProgress.totalUnitCount
//            ProgressHUD.progress(CGFloat(progress))
//        })
    }
    
    public func uploadVideo(_ video: Data, directory: String, callbackThread: DispatchQueue = .main, completion: @escaping (_ videoLink: String?) -> Void) {
        
        let reference = storage.reference(forURL: StorageKey.fileReference.rawValue).child(directory)
        var task: StorageUploadTask?
        task = reference.putData(video, completion: { metadata, error in
            task?.removeAllObservers()
            ProgressHUD.dismiss()
            
            if let error {
                print("error uploading video: \(error.localizedDescription)")
                return completion(nil)
            }
            
            reference.downloadURL { url, error in
                guard let downloadUrl = url else {
                    return completion(nil)
                }
                
                completion(downloadUrl.absoluteString)
            }
        })
        
        task?.observe(StorageTaskStatus.progress, handler: { snapshot in
            guard let snapshotProgress = snapshot.progress else {
                return
            }
            let progress = snapshotProgress.completedUnitCount / snapshotProgress.totalUnitCount
            ProgressHUD.progress(CGFloat(progress))
        })
    }
    
    public func uploadAudio(_ audioFileName: String, directory: String, completion: @escaping (_ audioLink: String?) -> Void) {
        let fileName = "\(audioFileName).m4a"
        let reference = storage.reference(forURL: StorageKey.fileReference.rawValue).child(directory)
        
        var task: StorageUploadTask?
        
        if fileExistsAtPath(path: fileName) {
            let data = NSData(contentsOfFile: fileInDocumentsDirectory(fileName: fileName))!
            
            task = reference.putData(data as Data, completion: { metadata, error in
                task?.removeAllObservers()
                ProgressHUD.dismiss()
                
                if let error {
                    print("error uploading audio: \(error.localizedDescription)")
                    return completion(nil)
                }
                
                reference.downloadURL { url, error in
                    guard let downloadUrl = url else {
                        return completion(nil)
                    }
                    
                    completion(downloadUrl.absoluteString)
                }
            })
            
            task?.observe(StorageTaskStatus.progress, handler: { snapshot in
                guard let snapshotProgress = snapshot.progress else {
                    return
                }
                let progress = snapshotProgress.completedUnitCount / snapshotProgress.totalUnitCount
                ProgressHUD.progress(CGFloat(progress))
            })
        }
    }
}
