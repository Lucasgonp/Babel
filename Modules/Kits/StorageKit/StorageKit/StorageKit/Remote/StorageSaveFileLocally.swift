extension StorageRemoteAdapter {
    public func saveFileLocally(fileData: NSData, fileName: String) {
        let docUrl = getDocumentsUrl().appending(path: fileName, directoryHint: .notDirectory)
        fileData.write(to: docUrl, atomically: true)
    }
}
