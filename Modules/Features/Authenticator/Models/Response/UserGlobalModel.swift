import FirebaseAuth

public struct UserGlobalModel {
    let authDataResult: AuthDataResult
    
    var isEmailVerified: Bool {
        authDataResult.user.isEmailVerified
    }
}
