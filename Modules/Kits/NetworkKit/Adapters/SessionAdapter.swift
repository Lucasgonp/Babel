//import Foundation
//
//public final class SessionAdapter {
//    public static let shared = SessionAdapter()
//    
//    private let session: URLSession
//    
//    private init(session: URLSession = .shared) {
//        self.session = session
//    }
//}
//
//extension SessionAdapter: HttpGetProtocol {
//    public func get<T: Decodable>(
//        to url: URL,
//        parameters: Encodable? = nil,
//        headers: [String: String]? = nil,
//        completion: @escaping (Result<T?, HttpError>) -> Void
//    ) {
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = HTTPMethod.GET.rawValue
//        urlRequest.allHTTPHeaderFields = headers
//        
//        if let parameters {
//            urlRequest.httpBody = try? JSONEncoder().encode(parameters)
//        }
//        
//        request(to: urlRequest, completion: completion)
//    }
//}
//
//extension SessionAdapter: HttpPostProtocol {
//    public func post<T: Decodable>(
//        to url: URL,
//        parameters: Encodable? = nil,
//        headers: [String: String]? = nil,
//        completion: @escaping (Result<T?, HttpError>) -> Void
//    ) {
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = HTTPMethod.GET.rawValue
//        urlRequest.allHTTPHeaderFields = headers
//        
//        if let parameters {
//            urlRequest.httpBody = try? JSONEncoder().encode(parameters)
//        }
//        
//        request(to: urlRequest, completion: completion)
//    }
//}
//
//private extension SessionAdapter {
//    func request<T: Decodable>(
//        to url: URLRequest,
//        completion: @escaping (Result<T?,HttpError>) -> Void
//    ) {
//        print(url.curlString)
//        session.dataTask(with: url) { [weak self] (data, response, error) in
//            guard let httpResponse = response as? HTTPURLResponse else {
//                return completion(.failure(.HTTPURLResponseError))
//            }
//            
//            self?.log(response: httpResponse, data: data, error: error)
//            
//            if let error {
//                return completion(.failure(.custom(error)))
//            }
//            
//            switch httpResponse.statusCode {
//            case 204:
//                completion(.success(nil))
//            case 200...299:
//                if let model: T = data?.toModel() {
//                    completion(.success(model))
//                } else {
//                    completion(.failure(.decodingError))
//                }
//            case 401:
//                completion(.failure(.unauthorized))
//            case 403:
//                completion(.failure(.forbidden))
//            case 400...499:
//                completion(.failure(.badRequest))
//            case 500...599:
//                completion(.failure(.serverError))
//            default:
//                completion(.failure(.noConnectivity))
//            }
//        }.resume()
//    }
//}
//
//extension URLRequest {
//    public var curlString: String {
//        guard let url = url else { return String() }
//        var baseCommand = #"cURL "\#(url.absoluteString)""#
//        
//        if httpMethod == "HEAD" {
//            baseCommand += " --head"
//        }
//        
//        var command = [baseCommand]
//        
//        if let method = httpMethod, method != "GET" && method != "HEAD" {
//            command.append("-X \(method)")
//        }
//        
//        if let headers = allHTTPHeaderFields {
//            for (key, value) in headers where key != "Cookie" {
//                command.append("-H '\(key): \(value)'")
//            }
//        }
//        
//        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
//            command.append("-d '\(body)'")
//        }
//        
//        return command.joined(separator: " \\\n\t")
//    }
//    
//    //    func log() {
//    //        print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
//    //
//    //        defer {
//    //            print("\n - - - - - - - - - -  END - - - - - - - - - - \n")
//    //        }
//    //
//    //        let urlAsString = url?.absoluteString ?? ""
//    //        let urlComponents = URLComponents(string: urlAsString)
//    //        let method = httpMethod != nil ? "\(httpMethod ?? "")" : ""
//    //        let path = "\(urlComponents?.path ?? "")"
//    //        let query = "\(urlComponents?.query ?? "")"
//    //        let host = "\(urlComponents?.host ?? "")"
//    //
//    //        var output = """
//    //       \(urlAsString) \n\n
//    //       \(method) \(path)?\(query) HTTP/1.1 \n
//    //       HOST: \(host)\n
//    //       """
//    //
//    //        for (key,value) in allHTTPHeaderFields ?? [:] {
//    //            output += "\(key): \(value) \n"
//    //        }
//    //
//    //        if let body = httpBody {
//    //            output += "\n \(String(data: body, encoding: .utf8) ?? "")"
//    //        }
//    //
//    //        print(output)
//    //    }
//    
//}
//
//extension SessionAdapter {
//    func log(response: HTTPURLResponse?, data: Data?, error: Error?) {
//        print("\n - - - - - - - - - - INCOMMING - - - - - - - - - - \n")
//        
//        defer {
//            print("\n - - - - - - - - - -  END - - - - - - - - - - \n")
//        }
//        
//        let urlString = response?.url?.absoluteString
//        let components = NSURLComponents(string: urlString ?? "")
//        let path = "\(components?.path ?? "")"
//        let query = "\(components?.query ?? "")"
//        var output = ""
//        
//        if let urlString = urlString {
//            output += "\(urlString)"
//            output += "\n\n"
//        }
//        
//        if let statusCode =  response?.statusCode {
//            output += "HTTP \(statusCode) \(path)?\(query)\n"
//        }
//        
//        if let host = components?.host {
//            output += "Host: \(host)\n"
//        }
//        
//        for (key, value) in response?.allHeaderFields ?? [:] {
//            output += "\(key): \(value)\n"
//        }
//        
//        if let body = data {
//            output += "\n\(String(data: body, encoding: .utf8) ?? "")\n"
//        }
//        
//        if error != nil {
//            output += "\nError: \(error!.localizedDescription)\n"
//        }
//        
//        print(output)
//    }
//}
