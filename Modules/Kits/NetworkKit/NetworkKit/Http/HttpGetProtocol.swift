public protocol HttpGetProtocol {
    func get(to url: URL, with data: Data?, completion: @escaping (Result<Data?,HttpError>) -> Void)
}
