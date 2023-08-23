import UIKit

public protocol Reusable {
    static var identifier: String { get }
}

public extension Reusable {
    static var identifier: String { String(describing: Self.self) }
}

public extension UITableView {
    final func register<T: UITableViewCell>(cellType: T.Type) {
        self.register(cellType.self, forCellReuseIdentifier: cellType.identifier)
    }
}

extension UITableViewCell: Reusable { }
