import Foundation

extension String {
    func format(_ arguments: CVarArg...) -> String {
        let args = arguments.map { String(describing: $0) } as [CVarArg]
        return String.init(format: self, arguments: args)
    }
}
