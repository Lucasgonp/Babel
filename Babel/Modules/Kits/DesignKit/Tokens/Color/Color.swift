import UIKit

public struct UserInterface {
    static public var style: UIUserInterfaceStyle? {
        UIApplication.shared.keyWindow?.rootViewController?.traitCollection.userInterfaceStyle
    }
}

public struct Color {
    private let style = UserInterface.style
    private var storage: AnyStorage
    
    public var hex: String {
        return UserInterface.style == .dark ? storage.dark.hex : storage.light.hex
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
        } else {
            return storage.light
        }
    }
    
    public var cgColor: CGColor { uiColor.cgColor }
    
    init(_ light: String, _ dark: String, opacity: CGFloat = 1) {
        self.storage = AnyStorage(
            light: light.isEmpty ? .clear : .init(hex: light).withAlphaComponent(opacity),
            dark: dark.isEmpty ? .clear : .init(hex: dark).withAlphaComponent(opacity)
        )
    }
    
    init(lightColor: UIColor, darkColor: UIColor, opacity: CGFloat = 1) {
        self.storage = AnyStorage(
            light: .init(hex: lightColor.hex).withAlphaComponent(opacity),
            dark: .init(hex: darkColor.hex).withAlphaComponent(opacity)
        )
    }
    
    init(_ light: UIColor, _ dark: UIColor, opacity: CGFloat = 1) {
        self.storage = AnyStorage(
            light: .init(hex: light.hex).withAlphaComponent(opacity),
            dark: .init(hex: dark.hex).withAlphaComponent(opacity)
        )
    }
    
    struct AnyStorage {
        let light: UIColor
        let dark: UIColor
    }
}
