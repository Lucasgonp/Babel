import FirebaseAuth

public struct LoginUserResponseModel {
    let authDataResult: AuthDataResult
    
    var isEmailVerified: Bool {
        authDataResult.user.isEmailVerified
    }
}
