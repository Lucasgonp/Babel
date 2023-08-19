import CoreKit
import FirebaseFirestoreSwift

public protocol RegisterProtocol {
    func registerUser(with userRequest: RegisterUserRequestModel, completion: @escaping (Bool, Error?) -> Void)
}

extension AuthenticatorAdapter: RegisterProtocol {
    public func registerUser(with userRequest: RegisterUserRequestModel, completion: @escaping (Bool, Error?) -> Void) {
        auth.createUser(withEmail: userRequest.email, password: userRequest.password) { [weak self] (result, error) in
            print("Register user result: \(String(describing: result))")
            print("Error: \(String(describing: error))")
            
            if let error {
                return completion(false, error)
            }
            
            guard let resultUser = result?.user else {
                return completion(false, nil)
            }
            
            resultUser.sendEmailVerification { (error) in
                print("Sent user verification")
                if let error {
                    completion(false, error)
                }
            }
            
            let user = User(
                id: resultUser.uid,
                pushId: "",
                avatarLink: "",
                name: userRequest.fullName,
                email: userRequest.email,
                username: userRequest.username,
                password: userRequest.password,
                status: "Hello there! I'm using Babel!"
            )
            self?.saveUserLocally(user)
            self?.saveUserToFirestore(user) { error in
                if let error {
                    print(error.localizedDescription, "Error in saveUserToFirestore")
                } else {
                    completion(true, nil)
                }
            }
        }
    }
}

private extension AuthenticatorAdapter {    
    func saveUserToFirestore(_ user: User, completion: @escaping (Error?) -> Void) {
        do {
            try firebaseReference(.user).document(user.id).setData(from: user, completion: { error in
                completion(error)
            })
        } catch let error {
            print(error.localizedDescription, "Error in saveUserToFirestore")
            completion(error)
        }
    }
}
