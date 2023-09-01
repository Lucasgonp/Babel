public enum FirebaseError: Error {
    case genericError
    case noDocumentFound
    case custom(Error)
}
