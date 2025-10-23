import SwiftData
import SwiftUI

@main
struct ShoppingList28aApp: App {
    @StateObject private var appState = AppState()
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .preferredColorScheme(appTheme.colorScheme)
        }
        .modelContainer(for: [ShoppingList.self, GroceryItem.self])
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                ThemeManager.apply(appTheme)
            }
        }
    }
}
