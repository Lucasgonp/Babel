import FirebaseAuth
import FirebaseFirestore

public protocol CheckAuthenticationProtocol {
    func checkAuthentication(completion: @escaping (AuthCredentials?) -> Void)
}

public protocol RegisterProtocol {
    func registerUser(with userRequest: RegisterUserModel, completion: @escaping (Bool, Error?) -> Void)
}

public protocol LoginProtocol {
    func login(with userRequest: LoginUserModel, completion: @escaping (Error?) -> Void)
}

public protocol LogoutProtocol {
    func logout(completion: @escaping (Error?) -> Void)
}

public struct AuthenticatorAdapter {
    private let auth: Auth
    private let database: Firestore
    
    public init(auth: Auth = .auth(), database: Firestore = .firestore()) {
        self.auth = auth
        self.database = database
    }
}

extension AuthenticatorAdapter: CheckAuthenticationProtocol {
    public func checkAuthentication(completion: @escaping (AuthCredentials?) -> Void) {
        if let user = Auth.auth().currentUser {
            let credentials = AuthCredentials(user: user)
            completion(credentials)
        } else {
            completion(nil)
        }
    }
}

extension AuthenticatorAdapter: RegisterProtocol {
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
    public func login(with userRequest: LoginUserModel, completion: @escaping (Error?) -> Void) {
        auth.signIn(withEmail: userRequest.email, password: userRequest.password) { (result, error) in
            if let error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}

extension AuthenticatorAdapter: LogoutProtocol {
    public func logout(completion: @escaping (Error?) -> Void) {
        do {
            try auth.signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
}
