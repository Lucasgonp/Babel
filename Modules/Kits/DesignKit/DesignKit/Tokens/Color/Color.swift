import UIKit

public protocol UserInterfaceDetectorProtocol {
    func getInterfaceStyle() -> UIUserInterfaceStyle?
}

public struct DefaultUserInterfaceDetector: UserInterfaceDetectorProtocol {
    public init () { }
    
    public func getInterfaceStyle() -> UIUserInterfaceStyle? {
        UIApplication.shared.keyWindow?.rootViewController?.traitCollection.userInterfaceStyle
    }
}

public struct Color {
    private var storage: AnyStorage
    private let userInterfaceDetector: UserInterfaceDetectorProtocol
    
    public var hex: String {
        return userInterfaceDetector.getInterfaceStyle() == .dark ? storage.dark.hex : storage.light.hex
    }
    
    public var uiColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return storage.dark
                default:
                    return storage.light
                }
            }
        }
    }
    
    public init(_ light: String, _ dark: String, opacity: CGFloat = 1, detector: UserInterfaceDetectorProtocol = DefaultUserInterfaceDetector()) {
        self.storage = AnyStorage(
            light: light.isEmpty ? .clear : .init(hex: light).withAlphaComponent(opacity),
            dark: dark.isEmpty ? .clear : .init(hex: dark).withAlphaComponent(opacity)
        )
        self.userInterfaceDetector = detector
    }
    
    public init(lightColor: UIColor, darkColor: UIColor, opacity: CGFloat = 1, detector: UserInterfaceDetectorProtocol = DefaultUserInterfaceDetector()) {
        self.storage = AnyStorage(
            light: .init(hex: lightColor.hex).withAlphaComponent(opacity),
            dark: .init(hex: darkColor.hex).withAlphaComponent(opacity)
        )
        self.userInterfaceDetector = detector
    }
    
    public init(_ light: UIColor, _ dark: UIColor, opacity: CGFloat = 1, detector: UserInterfaceDetectorProtocol = DefaultUserInterfaceDetector()) {
        self.storage = AnyStorage(
            light: .init(hex: light.hex).withAlphaComponent(opacity),
            dark: .init(hex: dark.hex).withAlphaComponent(opacity)
        )
        self.userInterfaceDetector = detector
    }
    
    struct AnyStorage {
        let light: UIColor
        let dark: UIColor
    }
}
