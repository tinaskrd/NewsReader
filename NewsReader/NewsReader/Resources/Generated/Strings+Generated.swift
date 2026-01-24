// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum Alert {
    public enum Button {
      /// Ok
      public static let ok = L10n.tr("Localizable", "alert.button.ok", fallback: "Ok")
    }
  }
  public enum Button {
    /// Reload
    public static let reload = L10n.tr("Localizable", "button.reload", fallback: "Reload")
    /// Share
    public static let share = L10n.tr("Localizable", "button.share", fallback: "Share")
  }
  public enum Image {
    /// square.and.arrow.up
    public static let share = L10n.tr("Localizable", "image.share", fallback: "square.and.arrow.up")
  }
  public enum Screen {
    public enum Articles {
      public enum Empty {
        /// We're apologize, but there are no news for this source
        public static let message = L10n.tr("Localizable", "screen.articles.empty.message", fallback: "We're apologize, but there are no news for this source")
        /// Ooops
        public static let title = L10n.tr("Localizable", "screen.articles.empty.title", fallback: "Ooops")
      }
    }
    public enum Feed {
      /// Localizable.strings
      ///   NewsReader
      /// 
      ///   Created by Tina  on 13.01.26.
      public static let title = L10n.tr("Localizable", "screen.feed.title", fallback: "Feed")
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
