public protocol AllGroupsClientProtocol {
    func downloadAllGroups<T: Decodable>(completion: @escaping ((Result<[T], FirebaseError>) -> Void))
}

extension FirebaseClient: AllGroupsClientProtocol {
    public func downloadAllGroups<T: Decodable>(completion: @escaping ((Result<[T], FirebaseError>) -> Void)) {
        groupListenner = firebaseReference(.group).limit(to: 500).addSnapshotListener( { (querySnapshot, error) in
            if let error {
                return completion(.failure(.custom(error)))
            }
            
            guard let document = querySnapshot?.documents else {
                return completion(.failure(.noDocumentFound))
            }
            
            let allGroups = document.compactMap({ try? $0.data(as: T.self) })
            completion(.success(allGroups))
        })
        
        /*
         
         firebaseReference(.group).limit(to: 500).getDocuments { (querySnapshot, error) in
             if let error {
                 return completion(.failure(.custom(error)))
             }
             
             guard let document = querySnapshot?.documents else {
                 return completion(.failure(.noDocumentFound))
             }
             
             let allUsers = document.compactMap({ try? $0.data(as: T.self) })
             completion(.success(allUsers))
         }
         */
    }
}
