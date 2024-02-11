import UIKit

public protocol Reusable {
    static var identifier: String { get }
}

public extension Reusable {
    static var identifier: String { String(describing: Self.self) }
}

public extension UICollectionView {
    final func register<T: UICollectionViewCell>(cellType: T.Type) {
        self.register(cellType.self, forCellWithReuseIdentifier: cellType.identifier)
    }
    
    final func register<T: UICollectionReusableView>(cellType: T.Type) {
        self.register(cellType.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellType.identifier)
    }
    
    final func makeCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            return T()
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = .zero
        return cell
    }
    
    final func makeView<T: UICollectionReusableView>(kind: String, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            return T()
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = .zero
        return cell
    }
}

extension UICollectionReusableView: Reusable { }
