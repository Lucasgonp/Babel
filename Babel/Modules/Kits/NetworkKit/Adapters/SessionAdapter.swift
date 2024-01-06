//import Dependencies
//import Alamofire
//
//public struct SessionAdapter {
//    private let session: Session
//    
//    public init(session: Session = .default) {
//        self.session = session
//    }
//}
//
//extension SessionAdapter: HttpGetProtocol {
//    public func get<T: Decodable>(
//        to url: URL,
//        with data: Data? = nil,
//        completion: @escaping (Result<T?,HttpError>) -> Void
//    ) {
//        request(to: url, method: .get, completion: completion)
//    }
//}
//
//extension SessionAdapter: HttpPostProtocol {
//    public func post<T: Decodable>(
//        to url: URL,
//        with data: Data? = nil,
//        completion: @escaping (Result<T?,HttpError>) -> Void
//    ) {
//        request(to: url, method: .post, completion: completion)
//    }
//}
//
//private extension SessionAdapter {
//    func request<T: Decodable>(
//        to url: URL,
//        with data: Data? = nil,
//        method: HTTPMethod,
//        completion: @escaping (Result<T?,HttpError>) -> Void
//    ) {
//        session.request(url, method: method, parameters: data?.toJson(), encoding: JSONEncoding.default).responseData { dataResponse in
//            print(dataResponse.debugDescription)
//            
//            guard let statusCode = dataResponse.response?.statusCode else {
//                return completion(.failure(.noConnectivity))
//            }
//            switch dataResponse.result {
//            case .failure: completion(.failure(.noConnectivity))
//            case .success(let data):
//                switch statusCode {
//                case 204:
//                    completion(.success(nil))
//                case 200...299:
//                    if let model: T = data.toModel() {
//                        completion(.success(model))
//                    } else {
//                        completion(.failure(.decodingError))
//                    }
//                case 401:
//                    completion(.failure(.unauthorized))
//                case 403:
//                    completion(.failure(.forbidden))
//                case 400...499:
//                    completion(.failure(.badRequest))
//                case 500...599:
//                    completion(.failure(.serverError))
//                default:
//                    completion(.failure(.noConnectivity))
//                }
//                
//            }
//        }.cURLDescription { description in
//            print(description)
//        }
//    }
//}
