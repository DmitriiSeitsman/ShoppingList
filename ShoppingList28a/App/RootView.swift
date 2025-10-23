import SwiftData
import SwiftUI

enum AppRoute: Hashable {
  case createList
  case storySet(ShoppingList)
  case addItem(ShoppingList)
}

struct RootView: View {
  @EnvironmentObject var appState: AppState
  @StateObject private var router = Router()

  var body: some View {
    NavigationStack(path: $router.path) {
      Group {
        if appState.hasSeenOnboarding {
          MainView()
            .environmentObject(router)
        } else {
          WelcomeView()
            .environmentObject(router)
        }
      }
      .navigationDestination(for: AppRoute.self) { route in
        switch route {
        case .createList:
          CreateListView()
            .environmentObject(router)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)

        case .storySet(let list):
          EmptyGroceryStateView(
            listName: list.name,
            onBack: { router.pop() },
            items: Binding(
              get: { list.items },
              set: { list.items = $0 }
            )
          )
          .environmentObject(router)
          .navigationBarBackButtonHidden(true)
          .navigationBarTitleDisplayMode(.inline)

        case .addItem(let list):
          AddItemView(
            items: Binding(
              get: { list.items },
              set: { list.items = $0 }
            )
          )
          .environmentObject(router)
          .navigationBarBackButtonHidden(true)
          .navigationBarTitleDisplayMode(.inline)
        }
      }
    }
  }
}

#Preview {
  RootView()
    .environmentObject(AppState())
    .modelContainer(for: [ShoppingList.self, GroceryItem.self], inMemory: true)
}
