import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
  case light, dark, system
  var id: String { rawValue }

  var title: String {
    switch self {
    case .light: return "Светлая"
    case .dark: return "Тёмная"
    case .system: return "Системная"
    }
  }

  var colorScheme: ColorScheme? {
    switch self {
    case .system: return nil
    case .light: return .light
    case .dark: return .dark
    }
  }
}
