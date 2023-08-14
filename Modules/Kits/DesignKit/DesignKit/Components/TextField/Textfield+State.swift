import UIKit

extension TextField {
    public enum State: Equatable {
        case none
        case success
        case error(String)

        var background: Color {
            switch self {
            case .none:
                return Color.secondary050
            case .success:
                return Color.success500
            case .error:
                return Color.warning050
            }
        }

        var cursor: Color {
            switch self {
            case .none:
                return Color.secondary800
            case .success:
                return Color.success500
            case .error:
                return Color.warning500
            }
        }
    }
}
