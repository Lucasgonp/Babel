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
                if let error {
                    return completion(false, error)
                }
            }
            
            let user = User(
                id: resultUser.uid,
                pushId: String(),
                avatarLink: String(),
                name: userRequest.fullName,
                email: userRequest.email,
                username: userRequest.username,
                password: userRequest.password,
                status: Strings.Register.UserBio.default.localized()
            )
            self?.saveUserToFirestore(user) { error in
                if let error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        }
    }
}
