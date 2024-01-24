import Foundation

extension String {
    enum LocalizedTable: String {
        case main = "Main"
    }
    
    func localized(table: LocalizedTable = .main) -> String {
        return String(localized: String.LocalizationValue(self), table: table.rawValue)
    }
    
    func format(_ arguments: CVarArg...) -> String {
        let args = arguments.map { String(describing: $0) } as [CVarArg]
        return String.init(format: self, arguments: args)
    }
}
