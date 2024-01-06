import FirebaseStorage

extension StorageAdapter {
    public func saveFileLocally(fileData: Data, fileName: String) {
        let docUrl = getDocumentsURL().appendingPathComponent(fileName, isDirectory: false)
        try! fileData.write(to: docUrl, options: .atomic)
    }
}
