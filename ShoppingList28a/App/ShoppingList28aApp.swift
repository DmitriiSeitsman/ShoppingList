import SwiftData
import SwiftUI

@main
struct ShoppingList28aApp: App {
  @StateObject private var appState = AppState()

  var body: some Scene {
    WindowGroup {
      RootView()
        .environmentObject(appState)
    }
    .modelContainer(for: [ShoppingList.self, GroceryItem.self])
  }
}
