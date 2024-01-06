public enum FirebaseError: Error {
    case genericError
    case noDocumentFound
    case errorDecodeUser
    case custom(Error)
}
