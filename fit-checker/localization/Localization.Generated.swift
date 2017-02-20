// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

// swiftlint:disable file_length
// swiftlint:disable line_length

// swiftlint:disable type_body_length
enum L10n {
  /// Courses
  case courses
  /// Odhlásit se
  case htmlLogoutVerifier
  /// Studuji:
  case jsonLogoutVerifier
  /// cs
  case langCode
  /// Login
  case login
  /// Logout
  case logout
  /// Password
  case password
  /// Settings
  case settings
  /// Username
  case username
}
// swiftlint:enable type_body_length

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
    switch self {
      case .courses:
        return L10n.tr(key: "courses")
      case .htmlLogoutVerifier:
        return L10n.tr(key: "html_logout_verifier")
      case .jsonLogoutVerifier:
        return L10n.tr(key: "json_logout_verifier")
      case .langCode:
        return L10n.tr(key: "lang_code")
      case .login:
        return L10n.tr(key: "login")
      case .logout:
        return L10n.tr(key: "logout")
      case .password:
        return L10n.tr(key: "password")
      case .settings:
        return L10n.tr(key: "settings")
      case .username:
        return L10n.tr(key: "username")
    }
  }

  private static func tr(key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

func tr(_ key: L10n) -> String {
  return key.string
}
