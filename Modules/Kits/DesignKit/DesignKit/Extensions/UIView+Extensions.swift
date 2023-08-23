import UIKit

public extension UIView {
    func pinToBounds(of view: UIView, customSpacing: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: customSpacing.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: customSpacing.right),
            topAnchor.constraint(equalTo: view.topAnchor, constant: customSpacing.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: customSpacing.bottom)
        ])
    }
    
    func fillWithSubview(subview: UIView, spacing: UIEdgeInsets = .zero, considerSafeArea: Bool = false, navigationSafeArea: Bool = false) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        
        let layoutTopAnchor = (navigationSafeArea || considerSafeArea) ? safeAreaLayoutGuide.topAnchor : topAnchor
        let layoutBottomAnchor = considerSafeArea ? safeAreaLayoutGuide.bottomAnchor : bottomAnchor
        let layoutLeadingAnchor = considerSafeArea ? safeAreaLayoutGuide.leadingAnchor : leadingAnchor
        let layoutTrailingAnchor = considerSafeArea ? safeAreaLayoutGuide.trailingAnchor : trailingAnchor
        
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: layoutLeadingAnchor, constant: spacing.left),
            subview.trailingAnchor.constraint(equalTo: layoutTrailingAnchor, constant: -spacing.right),
            subview.topAnchor.constraint(equalTo: layoutTopAnchor, constant: spacing.top),
            subview.bottomAnchor.constraint(equalTo: layoutBottomAnchor, constant: -spacing.bottom)
        ])
    }
}
