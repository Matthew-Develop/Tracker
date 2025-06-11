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
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal enum Colors {
    internal enum ColorSelection {
      internal static let color1 = ColorAsset(name: "Color 1")
      internal static let color10 = ColorAsset(name: "Color 10")
      internal static let color11 = ColorAsset(name: "Color 11")
      internal static let color12 = ColorAsset(name: "Color 12")
      internal static let color13 = ColorAsset(name: "Color 13")
      internal static let color14 = ColorAsset(name: "Color 14")
      internal static let color15 = ColorAsset(name: "Color 15")
      internal static let color16 = ColorAsset(name: "Color 16")
      internal static let color17 = ColorAsset(name: "Color 17")
      internal static let color18 = ColorAsset(name: "Color 18")
      internal static let color2 = ColorAsset(name: "Color 2")
      internal static let color3 = ColorAsset(name: "Color 3")
      internal static let color4 = ColorAsset(name: "Color 4")
      internal static let color5 = ColorAsset(name: "Color 5")
      internal static let color6 = ColorAsset(name: "Color 6")
      internal static let color7 = ColorAsset(name: "Color 7")
      internal static let color8 = ColorAsset(name: "Color 8")
      internal static let color9 = ColorAsset(name: "Color 9")
    }
    internal static let ypBackground = ColorAsset(name: "YP Background")
    internal static let ypBlack = ColorAsset(name: "YP Black")
    internal static let ypBlue = ColorAsset(name: "YP Blue")
    internal static let ypGray = ColorAsset(name: "YP Gray")
    internal static let ypLightGray = ColorAsset(name: "YP LightGray")
    internal static let ypRed = ColorAsset(name: "YP Red")
    internal static let ypSearchField = ColorAsset(name: "YP SearchField")
    internal static let ypWhite = ColorAsset(name: "YP White")
  }
  internal enum Images {
    internal static let arrowCategorySelector = ImageAsset(name: "ArrowCategorySelector")
    internal static let checkmarkCategorySelected = ImageAsset(name: "CheckmarkCategorySelected")
    internal static let completeTrackerButton = ImageAsset(name: "CompleteTrackerButton")
    internal static let doneTrackerButton = ImageAsset(name: "DoneTrackerButton")
    internal enum EmojiSelection {
      internal static let emoji1 = ImageAsset(name: "Emoji-1")
      internal static let emoji10 = ImageAsset(name: "Emoji-10")
      internal static let emoji11 = ImageAsset(name: "Emoji-11")
      internal static let emoji12 = ImageAsset(name: "Emoji-12")
      internal static let emoji13 = ImageAsset(name: "Emoji-13")
      internal static let emoji14 = ImageAsset(name: "Emoji-14")
      internal static let emoji15 = ImageAsset(name: "Emoji-15")
      internal static let emoji16 = ImageAsset(name: "Emoji-16")
      internal static let emoji17 = ImageAsset(name: "Emoji-17")
      internal static let emoji18 = ImageAsset(name: "Emoji-18")
      internal static let emoji2 = ImageAsset(name: "Emoji-2")
      internal static let emoji3 = ImageAsset(name: "Emoji-3")
      internal static let emoji4 = ImageAsset(name: "Emoji-4")
      internal static let emoji5 = ImageAsset(name: "Emoji-5")
      internal static let emoji6 = ImageAsset(name: "Emoji-6")
      internal static let emoji7 = ImageAsset(name: "Emoji-7")
      internal static let emoji8 = ImageAsset(name: "Emoji-8")
      internal static let emoji9 = ImageAsset(name: "Emoji-9")
    }
    internal static let ifEmptyTrackers = ImageAsset(name: "IfEmptyTrackers")
    internal static let launchLogo = ImageAsset(name: "LaunchLogo")
    internal static let plusAddTracker = ImageAsset(name: "PlusAddTracker")
    internal static let onboarding1 = ImageAsset(name: "onboarding_1")
    internal static let onboarding2 = ImageAsset(name: "onboarding_2")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
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
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
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
internal extension SwiftUI.Image {
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
