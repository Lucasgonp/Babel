import UIKit
import FirebaseStorage
import ProgressHUD

public protocol StorageRemoteUploadImageProtocol {
    func uploadImage(_ image: UIImage, directory: String, callbackThread: DispatchQueue, completion: @escaping (_ documentLink: String?) -> Void)
}

extension StorageRemoteAdapter: StorageRemoteUploadImageProtocol {
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
        
        task?.observe(StorageTaskStatus.progress, handler: { snapshot in
            guard let snapshotProgress = snapshot.progress else {
                return
            }
            let progress = snapshotProgress.completedUnitCount / snapshotProgress.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        })
    }
}
