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
  internal enum AddHabitVC {
    /// New habit
    internal static let title = L10n.tr("Localizable", "addHabitVC.title", fallback: "New habit")
  }
  internal enum AddTrackerVC {
    /// Habit
    internal static let habitButton = L10n.tr("Localizable", "addTrackerVC.habitButton", fallback: "Habit")
    /// Add tracker
    internal static let title = L10n.tr("Localizable", "addTrackerVC.title", fallback: "Add tracker")
    /// Enter tracker name
    internal static let trackerNamePlaceholder = L10n.tr("Localizable", "addTrackerVC.trackerNamePlaceholder", fallback: "Enter tracker name")
    /// Unregular event
    internal static let unregularButton = L10n.tr("Localizable", "addTrackerVC.unregularButton", fallback: "Unregular event")
    internal enum ColorPallette {
      /// Color
      internal static let title = L10n.tr("Localizable", "addTrackerVC.colorPallette.title", fallback: "Color")
    }
    internal enum Emoji {
      /// Emoji
      internal static let title = L10n.tr("Localizable", "addTrackerVC.emoji.title", fallback: "Emoji")
    }
  }
  internal enum AddUnregularVC {
    /// New unregular event
    internal static let title = L10n.tr("Localizable", "addUnregularVC.title", fallback: "New unregular event")
  }
  internal enum Buttons {
    /// Cancel
    internal static let cancelButton = L10n.tr("Localizable", "buttons.cancelButton", fallback: "Cancel")
    /// Category
    internal static let categorySelectionButton = L10n.tr("Localizable", "buttons.categorySelectionButton", fallback: "Category")
    /// Create
    internal static let createButton = L10n.tr("Localizable", "buttons.createButton", fallback: "Create")
    /// Done
    internal static let doneButton = L10n.tr("Localizable", "buttons.doneButton", fallback: "Done")
    /// Schedule
    internal static let scheduleSelectionButton = L10n.tr("Localizable", "buttons.scheduleSelectionButton", fallback: "Schedule")
  }
  internal enum CategoryListVC {
    /// Add category
    internal static let addCategoryButton = L10n.tr("Localizable", "categoryListVC.addCategoryButton", fallback: "Add category")
    /// Habits and events possible
    /// to collect into groups
    internal static let ifEmptyText = L10n.tr("Localizable", "categoryListVC.ifEmptyText", fallback: "Habits and events possible\nto collect into groups")
    /// Category
    internal static let title = L10n.tr("Localizable", "categoryListVC.title", fallback: "Category")
  }
  internal enum NewCategoryVC {
    /// Enter category name
    internal static let categoryNamePlaceholder = L10n.tr("Localizable", "newCategoryVC.categoryNamePlaceholder", fallback: "Enter category name")
    /// New category
    internal static let title = L10n.tr("Localizable", "newCategoryVC.title", fallback: "New category")
  }
  internal enum Onboarding {
    /// Wow, technologies!
    internal static let button = L10n.tr("Localizable", "onboarding.button", fallback: "Wow, technologies!")
    internal enum Vc1 {
      /// Track whatever you want
      internal static let title = L10n.tr("Localizable", "onboarding.vc1.title", fallback: "Track whatever you want")
    }
    internal enum Vc2 {
      /// Even it's not liters of water or yoga
      internal static let title = L10n.tr("Localizable", "onboarding.vc2.title", fallback: "Even it's not liters of water or yoga")
    }
  }
  internal enum ScheduleListVC {
    /// Schedule
    internal static let title = L10n.tr("Localizable", "scheduleListVC.title", fallback: "Schedule")
    internal enum DaysOfWeek {
      /// Every day
      internal static let everyDay = L10n.tr("Localizable", "scheduleListVC.daysOfWeek.everyDay", fallback: "Every day")
      /// Friday
      internal static let friday = L10n.tr("Localizable", "scheduleListVC.daysOfWeek.friday", fallback: "Friday")
      /// Monday
      internal static let monday = L10n.tr("Localizable", "scheduleListVC.daysOfWeek.monday", fallback: "Monday")
      /// Saturday
      internal static let saturday = L10n.tr("Localizable", "scheduleListVC.daysOfWeek.saturday", fallback: "Saturday")
      /// Sunday
      internal static let sunday = L10n.tr("Localizable", "scheduleListVC.daysOfWeek.sunday", fallback: "Sunday")
      /// Thursday
      internal static let thursday = L10n.tr("Localizable", "scheduleListVC.daysOfWeek.thursday", fallback: "Thursday")
      /// Tuesday
      internal static let tuesday = L10n.tr("Localizable", "scheduleListVC.daysOfWeek.tuesday", fallback: "Tuesday")
      /// Wednesday
      internal static let wednesday = L10n.tr("Localizable", "scheduleListVC.daysOfWeek.wednesday", fallback: "Wednesday")
      internal enum Friday {
        /// Fri
        internal static let short = L10n.tr("Localizable", "scheduleListVC.daysOfWeek.friday.short", fallback: "Fri")
      }
      internal enum Monday {
        /// Mon
        internal static let short = L10n.tr("Localizable", "scheduleListVC.daysOfWeek.monday.short", fallback: "Mon")
      }
      internal enum Saturday {
        /// Sat
        internal static let short = L10n.tr("Localizable", "scheduleListVC.daysOfWeek.saturday.short", fallback: "Sat")
      }
      internal enum Sunday {
        /// Sun
        internal static let short = L10n.tr("Localizable", "scheduleListVC.daysOfWeek.sunday.short", fallback: "Sun")
      }
      internal enum Thursday {
        /// Thu
        internal static let short = L10n.tr("Localizable", "scheduleListVC.daysOfWeek.thursday.short", fallback: "Thu")
      }
      internal enum Tuesday {
        /// Tue
        internal static let short = L10n.tr("Localizable", "scheduleListVC.daysOfWeek.tuesday.short", fallback: "Tue")
      }
      internal enum Wednesday {
        /// Wed
        internal static let short = L10n.tr("Localizable", "scheduleListVC.daysOfWeek.wednesday.short", fallback: "Wed")
      }
    }
  }
  internal enum TabBar {
    internal enum Statistics {
      /// Statistics
      internal static let iconTitle = L10n.tr("Localizable", "tabBar.statistics.iconTitle", fallback: "Statistics")
    }
    internal enum Trackers {
      /// Trackers
      internal static let iconTitle = L10n.tr("Localizable", "tabBar.trackers.iconTitle", fallback: "Trackers")
    }
  }
  internal enum TrackerVC {
    /// What we will track?
    internal static let ifEmptyText = L10n.tr("Localizable", "trackerVC.ifEmptyText", fallback: "What we will track?")
    /// Search
    internal static let searchPlaceholder = L10n.tr("Localizable", "trackerVC.searchPlaceholder", fallback: "Search")
    /// Trackers
    internal static let title = L10n.tr("Localizable", "trackerVC.title", fallback: "Trackers")
  }
  internal enum Warnings {
    /// Category already exists
    internal static let categoryAlreadyExists = L10n.tr("Localizable", "warnings.categoryAlreadyExists", fallback: "Category already exists")
    /// Limit %d symbols
    internal static func symbolLimit(_ p1: Int) -> String {
      return L10n.tr("Localizable", "warnings.symbolLimit", p1, fallback: "Limit %d symbols")
    }
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
