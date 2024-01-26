//import Foundation
//
//public typealias WLScheme = String
//public typealias DeeplinkCoreParameters = [DeeplinkCoreParameter]
//public typealias DeeplinkCoreComponents = URLComponents
//public typealias DeeplinkCoreParameter = URLQueryItem
//
//public protocol DeeplinkCoreValueProtocol {
//    init?(components: DeeplinkCoreComponents, parameters: DeeplinkCoreParameters?)
//    init?(from url: URL)
//    init?(from urlString: String)
//    var components: DeeplinkCoreComponents { get }
//    var parameters: DeeplinkCoreParameters? { get }
//}
//
//public struct DeeplinkCoreValue: DeeplinkCoreValueProtocol, Equatable {
//    
//    public var components: DeeplinkCoreComponents
//    public var parameters: DeeplinkCoreParameters?
//    
//    public init?(components: DeeplinkCoreComponents, parameters: DeeplinkCoreParameters? = nil) {
//        guard components.isValidDeeplink else {
//            return nil
//        }
//        
//        self.components = components
//        self.parameters = parameters
//    }
//    
//    public init?(from url: URL) {
//        guard let components = DeeplinkCoreComponents(url: url, resolvingAgainstBaseURL: true),
//              components.isValidDeeplink else {
//            return nil
//        }
//        
//        let params = components.queryItems
//        self.init(components: components, parameters: params)
//    }
//    
//    public init?(from urlString: String) {
//        if let url = URL(string: urlString) {
//            self.init(from: url)
//        } else {
//            return nil
//        }
//    }
//}
//
//extension DeeplinkCoreValue {
//    public var parametersDictionary: [String: String]? {
//        return parameters?.reduce(into: [String: String]()) { $0[$1.name] = $1.value }
//    }
//}
//
//extension Optional where Wrapped == String {
//    var isNullOrEmpty: Bool {
//        if let safeSelf = self {
//            return safeSelf.isEmpty
//        }
//        return true
//    }
//}
//
//extension DeeplinkCoreComponents {
//    var isValidDeeplink: Bool {
//        !(scheme.isNullOrEmpty || host.isNullOrEmpty)
//    }
//}
