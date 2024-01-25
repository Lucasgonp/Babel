import Foundation

extension String {
    enum LocalizedTable: String {
        case main = "Main"
    }
    
    func localized(table: LocalizedTable = .main) -> String {
        return String(localized: String.LocalizationValue(self), table: table.rawValue, bundle: AuthenticatorResources.resourcesBundle)
    }
}
