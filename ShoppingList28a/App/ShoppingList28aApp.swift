import SwiftUI

@main
struct ShoppingList28aApp: App {
    @StateObject private var appState = AppState()
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .preferredColorScheme(appTheme.colorScheme)
                .onAppear {
                    ThemeManager.apply(appTheme)
                }
                .onChange(of: appTheme) { _, _ in
                    ThemeManager.apply(appTheme)
                }
        }
    }
}
