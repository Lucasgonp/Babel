import UIKit

public enum ThemeColor {
    case light
    case dark
    
    var color: UIColor {
        switch self {
        case .light:
            return .systemIndigo
        case .dark:
            return .systemCyan
        }
    }
}

public final class DesignView: UIView {
    private let theme: ThemeColor
    
    public init(theme: ThemeColor) {
        self.theme = theme
        super.init(frame: .zero)
        buildView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildView() {
        backgroundColor = theme.color
    }
}
