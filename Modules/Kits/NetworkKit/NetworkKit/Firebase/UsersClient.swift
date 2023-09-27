import Foundation
import FirebaseFirestoreSwift

public protocol UsersClientProtocol {
    func downloadAllUsers<T: Decodable>(completion: @escaping ((Result<[T], FirebaseError>) -> Void))
    func downloadUsers<T: Decodable>(withIds: [String], completion: @escaping ((Result<[T], FirebaseError>) -> Void))
}

extension FirebaseClient: UsersClientProtocol {
    public func downloadAllUsers<T: Decodable>(completion: @escaping ((Result<[T], FirebaseError>) -> Void)) {
        firebaseReference(.user).limit(to: 500).getDocuments { (querySnapshot, error) in
            if let error {
                return completion(.failure(.custom(error)))
            }
            
            guard let document = querySnapshot?.documents else {
                return completion(.failure(.noDocumentFound))
            }
            
            let allUsers = document.compactMap({ try? $0.data(as: T.self) })
            completion(.success(allUsers))
        }
    }
    
    public func downloadUsers<T: Decodable>(withIds: [String], completion: @escaping ((Result<[T], FirebaseError>) -> Void)) {
        var users = [T]()
        for id in withIds {
            firebaseReference(.user).document(id).getDocument { (querySnapshot, error) in
                if let error {
                    return completion(.failure(.custom(error)))
                }
                
                guard let document = querySnapshot else {
                    return completion(.failure(.noDocumentFound))
                }
                
                do {
                    let user = try document.data(as: T.self)
                    users.append(user)
                } catch {
                    return
                }
            }
        }
        completion(.success(users))
    }
}
