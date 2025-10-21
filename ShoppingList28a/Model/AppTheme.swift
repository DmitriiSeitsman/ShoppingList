import UIKit
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
    
    var uiInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return .unspecified
        }
    }
}

struct ThemeManager {
    static func apply(_ theme: AppTheme) {
        guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first,
              let window = windowScene.windows.first else {
            return
        }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            window.overrideUserInterfaceStyle = theme.uiInterfaceStyle
        }
    }
}
