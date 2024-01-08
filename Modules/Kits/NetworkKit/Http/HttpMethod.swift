import Foundation

public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

protocol EndpointProtocol {
    var path: String { get }
    var baseUrl: String { get }
    var url: URL? { get }
    var method: HTTPMethod { get }
}
