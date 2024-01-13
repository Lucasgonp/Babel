public protocol GroupClientProtocol {
    func downloadGroup<T: Decodable>(id: String, completion: @escaping ((Result<T, FirebaseError>) -> Void))
}

extension FirebaseClient: GroupClientProtocol {
    public func downloadGroup<T: Decodable>(id: String, completion: @escaping ((Result<T, FirebaseError>) -> Void)) {
        firebaseReference(.group).document(id).getDocument { (querySnapshot, error) in
            if let error {
                return completion(.failure(.custom(error)))
            }
            
            guard let document = querySnapshot else {
                return completion(.failure(.noDocumentFound))
            }
            
            do {
                let user = try document.data(as: T.self)
                completion(.success(user))
            } catch {
                return completion(.failure(.errorDecodeUser))
            }
        }
    }
}
