import FirebaseAuth
import FirebaseFirestore

public struct AuthenticatorAdapter {    
    private let auth: Auth
    private let database: Firestore
    
    public init(auth: Auth = .auth(), database: Firestore = .firestore()) {
        self.auth = auth
        self.database = database
    }
}

extension AuthenticatorAdapter: CheckAuthenticationProtocol {
    /// Check Authentication
    /// - Parameter completion: Return with optional Credentials model, if it's nil should handle as error
    public func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void) {
        if let user = Auth.auth().currentUser {
            let credentials = AuthCheckCredentials(user: user)
            completion(credentials)
        } else {
            completion(nil)
        }
    }
}

extension AuthenticatorAdapter: RegisterProtocol {
    /// Register new user
    /// - Parameters:
    ///   - userRequest: User params to request sign in
    ///   - completion: Return (Bool) if succeeded, with optional Error
    public func registerUser(with userRequest: RegisterUserModel, completion: @escaping (Bool, Error?) -> Void) {
        auth.createUser(withEmail: userRequest.email, password: userRequest.password) { (result, error) in
            print("Register user result: \(String(describing: result))")
            print("Error: \(String(describing: error))")
            
            if let error {
                return completion(false, error)
            }
            
            guard let resultUser = result?.user else {
                return completion(false, nil)
            }
            
            let database = Firestore.firestore()
            database.collection("users")
                .document(resultUser.uid)
                .setData([
                    "name": userRequest.name,
                    "email": userRequest.email,
                    "username": userRequest.username
                ]) { error in
                    if let error {
                        return completion(false, error)
                    }
                    
                    completion(true, nil)
                }
        }
    }
}

extension AuthenticatorAdapter: LoginProtocol {
    /// Log In
    /// - Parameters:
    ///   - userRequest: User params to request log in
    ///   - completion: Return (AuthDataResult) if succeeded, with optional Error
    public func login(with userRequest: LoginUserModel, completion: @escaping ((AuthDataResult?, (any Error)?) -> Void)) {
        auth.signIn(withEmail: userRequest.email, password: userRequest.password) { (result, error) in
            completion(result, error)
        }
    }
}

extension AuthenticatorAdapter: LogoutProtocol {
    /// Log out
    /// - Parameter completion: Return with optional error model, if it's nil should handle as success
    public func logout(completion: @escaping (Error?) -> Void) {
        do {
            try auth.signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
}
