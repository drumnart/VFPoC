// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// All
  internal static let all = L10n.tr("Localizable", "all")
  /// Continue
  internal static let `continue` = L10n.tr("Localizable", "continue")
  /// Finish
  internal static let finish = L10n.tr("Localizable", "finish")
  /// %d likes
  internal static func likes(_ p1: Int) -> String {
    return L10n.tr("Localizable", "likes", p1)
  }
  /// Skip
  internal static let skip = L10n.tr("Localizable", "skip")

  internal enum Feed {
    /// Shop Now
    internal static let shopNow = L10n.tr("Localizable", "feed.shop_now")
  }

  internal enum Gender {
    /// Female
    internal static let female = L10n.tr("Localizable", "gender.female")
    /// Male
    internal static let male = L10n.tr("Localizable", "gender.male")
  }

  internal enum Onboarding {
    internal enum Birthday {
      /// When were you born?
      internal static let text1 = L10n.tr("Localizable", "onboarding.birthday.text1")
      /// Also we’ll perform better if you tell us the year you were born.
      internal static let text2 = L10n.tr("Localizable", "onboarding.birthday.text2")
    }
    internal enum Gender {
      /// How do you identify yourself?
      internal static let text1 = L10n.tr("Localizable", "onboarding.gender.text1")
      /// You’ll help us to provide a better user experience by choosing the gender.
      internal static let text2 = L10n.tr("Localizable", "onboarding.gender.text2")
    }
    internal enum Preferences {
      /// What are your favourite categories?
      internal static let text1 = L10n.tr("Localizable", "onboarding.preferences.text1")
      /// Choose at least 3.
      internal static let text2 = L10n.tr("Localizable", "onboarding.preferences.text2")
    }
  }

  internal enum TabBarItem {
    /// Cart
    internal static let cart = L10n.tr("Localizable", "tab_bar_item.cart")
    /// Favorites
    internal static let favorites = L10n.tr("Localizable", "tab_bar_item.favorites")
    /// TOBOX
    internal static let feed = L10n.tr("Localizable", "tab_bar_item.feed")
    /// Profile
    internal static let profile = L10n.tr("Localizable", "tab_bar_item.profile")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
