// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Plural format key: "%#@days@"
  internal static func daysCompleted(_ p1: Int) -> String {
    return L10n.tr("Localizable", "daysCompleted", p1, fallback: "Plural format key: \"%#@days@\"")
  }
  internal enum AddTrackerVC {
    /// Habit
    internal static let habitButton = L10n.tr("Localizable", "addTrackerVC.habitButton", fallback: "Habit")
    /// Add tracker
    internal static let title = L10n.tr("Localizable", "addTrackerVC.title", fallback: "Add tracker")
    /// Unregular event
    internal static let unregularButton = L10n.tr("Localizable", "addTrackerVC.unregularButton", fallback: "Unregular event")
  }
  internal enum StatisticsTabBar {
    /// Statistics
    internal static let iconTitle = L10n.tr("Localizable", "statisticsTabBar.iconTitle", fallback: "Statistics")
  }
  internal enum TrackerVC {
    /// Search
    internal static let searchPlaceholder = L10n.tr("Localizable", "trackerVC.searchPlaceholder", fallback: "Search")
    /// Trackers
    internal static let title = L10n.tr("Localizable", "trackerVC.title", fallback: "Trackers")
  }
  internal enum TrackersTabBar {
    /// Trackers
    internal static let iconTitle = L10n.tr("Localizable", "trackersTabBar.iconTitle", fallback: "Trackers")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

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
