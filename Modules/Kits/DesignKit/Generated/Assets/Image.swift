// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Image {
  public static let babelBrandLogo = ImageAsset(name: "babel-brand-logo")
  public static let chatBackgroundImage1 = ImageAsset(name: "chat-background-image-1")
  public static let chatBackgroundImage10 = ImageAsset(name: "chat-background-image-10")
  public static let chatBackgroundImage11 = ImageAsset(name: "chat-background-image-11")
  public static let chatBackgroundImage12 = ImageAsset(name: "chat-background-image-12")
  public static let chatBackgroundImage13 = ImageAsset(name: "chat-background-image-13")
  public static let chatBackgroundImage14 = ImageAsset(name: "chat-background-image-14")
  public static let chatBackgroundImage15 = ImageAsset(name: "chat-background-image-15")
  public static let chatBackgroundImage2 = ImageAsset(name: "chat-background-image-2")
  public static let chatBackgroundImage3 = ImageAsset(name: "chat-background-image-3")
  public static let chatBackgroundImage4 = ImageAsset(name: "chat-background-image-4")
  public static let chatBackgroundImage5 = ImageAsset(name: "chat-background-image-5")
  public static let chatBackgroundImage6 = ImageAsset(name: "chat-background-image-6")
  public static let chatBackgroundImage7 = ImageAsset(name: "chat-background-image-7")
  public static let chatBackgroundImage8 = ImageAsset(name: "chat-background-image-8")
  public static let chatBackgroundImage9 = ImageAsset(name: "chat-background-image-9")
  public static let avatarGroupPlaceholder = ImageAsset(name: "avatar-group-placeholder")
  public static let avatarPlaceholder = ImageAsset(name: "avatar-placeholder")
  public static let photoPlaceholder = ImageAsset(name: "photo-placeholder")

  // swiftlint:disable trailing_comma
  @available(*, deprecated, message: "All values properties are now deprecated")
  public static let allImages: [ImageAsset] = [
    babelBrandLogo,
    chatBackgroundImage1,
    chatBackgroundImage10,
    chatBackgroundImage11,
    chatBackgroundImage12,
    chatBackgroundImage13,
    chatBackgroundImage14,
    chatBackgroundImage15,
    chatBackgroundImage2,
    chatBackgroundImage3,
    chatBackgroundImage4,
    chatBackgroundImage5,
    chatBackgroundImage6,
    chatBackgroundImage7,
    chatBackgroundImage8,
    chatBackgroundImage9,
    avatarGroupPlaceholder,
    avatarPlaceholder,
    photoPlaceholder,
  ]
  // swiftlint:enable trailing_comma
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  public var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  public func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

public extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
