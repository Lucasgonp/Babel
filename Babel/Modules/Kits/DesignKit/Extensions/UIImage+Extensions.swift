import UIKit

extension Image {
    public enum IconSize: RawRepresentable {
        case large
        case medium

        public init?(rawValue: CGSize) {
            switch (rawValue.width, rawValue.height) {
            case (16, 16):
                self = .medium
            case (24, 24):
                self = .large
            default:
                self = .medium
            }
        }

        public var rawValue: CGSize {
            switch self {
            case .large:
                return .init(width: 24, height: 24)
            case .medium:
                return .init(width: 16, height: 16)
            }
        }
    }
    
    public enum IllustationSize: RawRepresentable, CaseIterable {
        case large
        case medium
        case small

        public init?(rawValue: CGSize) {
            switch (rawValue.width, rawValue.height) {
            case (176, 176):
                self = .large
            case (144, 144):
                self = .medium
            case (56, 56):
                self = .small
            default:
                self = .medium
            }
        }

        public var rawValue: CGSize {
            switch self {
            case .large:
                return .init(width: 176, height: 176)
            case .medium:
                return .init(width: 144, height: 144)
            case .small:
                return .init(width: 56, height: 56)
            }
        }
    }
}
