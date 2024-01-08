public protocol HttpGetProtocol {
    func get<T: Decodable>(
        to url: URL,
        parameters: Encodable?,
        headers: [String: String]?,
        completion: @escaping (Result<T?, HttpError>) -> Void
    )
}
