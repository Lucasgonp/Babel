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
    
    final func makeCell<T: UITableViewCell>(
        indexPath: IndexPath,
        accessoryType: UITableViewCell.AccessoryType = .none,
        selectionStyle: UITableViewCell.SelectionStyle = .default,
        accessoryView: UIView? = nil
    ) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            return T()
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.selectionStyle = selectionStyle
        cell.accessoryType = accessoryType
        cell.accessoryView = accessoryView
        return cell
    }
}

extension UITableViewCell: Reusable { }
