import SwiftUI
import SwiftData

enum AppRoute: Hashable {
    case createList
    case storySet(ShoppingList)
    case addItem(ShoppingList)
    case editList(ShoppingList)
}

struct RootView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var modelContext
    @Query private var lists: [ShoppingList]
    @StateObject private var router = Router()
    @AppStorage("appTheme") private var appTheme: AppTheme = .system

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
                        .navigationBarHidden(true)
                        .toolbar(.hidden, for: .navigationBar)

                case .storySet(let list):
                    let viewModel = GroceryListViewModel(
                        shoppingList: list,
                        modelContext: modelContext
                    )
                    GroceryListView(viewModel: viewModel)
                        .environmentObject(router)
                        .navigationBarHidden(true)
                        .toolbar(.hidden, for: .navigationBar)

                case .addItem(let list):
                    AddItemView(shoppingList: list)
                        .environmentObject(router)
                        .navigationBarHidden(true)
                        .toolbar(.hidden, for: .navigationBar)
                case .editList(let list):
                    CreateListView(editingList: list)
                        .environmentObject(router)
                        .navigationBarHidden(true)
                        .toolbar(.hidden, for: .navigationBar)
                }
            }
        }
        .preferredColorScheme(appTheme.colorScheme)
        .onAppear {
            ThemeManager.apply(appTheme)
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
        .modelContainer(for: [ShoppingList.self, GroceryItem.self], inMemory: true)
}
