import UIKit

extension String {
    enum LocalizedTable: String {
        case main = "Main"
    }
    
    func localized(table: LocalizedTable = .main) -> String {
        return String(localized: String.LocalizationValue(self), table: table.rawValue, bundle: DesignKitResources.resourcesBundle)
    }
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
