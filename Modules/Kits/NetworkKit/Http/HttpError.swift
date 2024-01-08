public enum HttpError: Error {
    case noConnectivity
    case badRequest
    case serverError
    case unauthorized
    case forbidden
    case decodingError
    case HTTPURLResponseError
    case custom(Error)
}
