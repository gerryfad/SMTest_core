// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// MARK: - Strings

/// Localizable strings (Suitmedia)
internal enum Lstr: String {
  case cancel
  internal static func hiX(_ p1: String) -> String {
    return Lstr.tr("hiX", p1)
  }
  case language
  case login
  case news
  case repository
  case selectLanguage
  case selectLanguageForThisApp
  case somethingWentWrong
  case test

  /// translate by device language
  func trd() -> String {
    return Lstr.trd("Localizable", self.rawValue)
  }

  /// translate by preference language
  func tr() -> String {
    return Lstr.tr(self.rawValue)
  }

  /// manually translate by language
  func tr(_ language: ProjLanguage) -> String {
    return Lstr.tr(language, self.rawValue)
  }
}

// MARK: - Implementation Details

extension Lstr {
  private static func trd(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }

  private static func tr(_ key: String, _ args: CVarArg...) -> String {
    let format = LocaleManager.instance.localizedStringForKey(key: key)
    return String(format: format, arguments: args)
  }

  private static func tr(_ language: ProjLanguage, _ key: String, _ args: CVarArg...) -> String {
    let format = LocaleManager.instance.localizedStringForKey(key: key, language: language)
    return String(format: format, arguments: args)
  }
}

private final class BundleToken {}
