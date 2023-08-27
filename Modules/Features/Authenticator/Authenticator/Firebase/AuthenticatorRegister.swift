import FirebaseFirestoreSwift

public protocol RegisterProtocol {
    func registerUser(with userRequest: RegisterUserRequestModel, thread: DispatchQueue, completion: @escaping (Bool, Error?) -> Void)
}

extension AuthenticatorAdapter: RegisterProtocol {
    public func registerUser(with userRequest: RegisterUserRequestModel, thread: DispatchQueue = .main, completion: @escaping (Bool, Error?) -> Void) {
        auth.createUser(withEmail: userRequest.email, password: userRequest.password) { [weak self] (result, error) in
            print("Register user result: \(String(describing: result))")
            print("Error: \(String(describing: error))")
            
            if let error {
                thread.async {
                    return completion(false, error)
                }
            }
            
            guard let resultUser = result?.user else {
                thread.async {
                    completion(false, nil)
                }
                return
            }
            
            resultUser.sendEmailVerification { (error) in
                print("Sent user verification")
                if let error {
                    thread.async {
                        completion(false, error)
                    }
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
            self?.saveUserToFirestore(user, thread: thread) { error in
                if let error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        }
    }
}
