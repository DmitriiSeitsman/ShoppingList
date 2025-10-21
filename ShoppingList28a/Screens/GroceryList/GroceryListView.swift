import SwiftUI
import SwiftData

struct GroceryListView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var viewModel: GroceryListViewModel
    
    init(shoppingList: ShoppingList) {
        _viewModel = StateObject(wrappedValue: GroceryListViewModel(shoppingList: shoppingList))
    }
    
    // Вычисляемое свойство для количества купленных товаров
    private var purchasedCount: Int {
        viewModel.shoppingList.purchasedCount
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            GroceryListTopBar(
                listName: viewModel.shoppingList.name,
                onBack: { dismiss() },
                onMenu: { viewModel.showingMenu = true }
            )
            
            // Search Bar
            SearchBarView(searchText: $viewModel.searchText)
                .padding(.vertical, 12)
                .background(Color.slBackground)
            
            // Content
            if viewModel.filteredItems.isEmpty {
                EmptyGroceryStateView(onAddItem: { viewModel.showingAddItem = true })
            } else {
                GroceryItemsList(
                    items: Binding(
                        get: { viewModel.shoppingList.items },
                        set: { newItems in
                            viewModel.shoppingList.items = newItems
                            viewModel.updateItems()
                        }
                    ),
                    purchasedCount: purchasedCount,
                    onAddItem: { viewModel.showingAddItem = true },
                    onDelete: viewModel.deleteItem,
                    onDeleteAllPurchased: { viewModel.clearPurchased() }
                )
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.showingAddItem) {
            AddItemView(items: Binding(
                get: { viewModel.shoppingList.items },
                set: { newItems in
                    viewModel.shoppingList.items = newItems
                    viewModel.updateItems()
                }
            ))
        }
        
        .overlay(
            Group {
                if viewModel.showingMenu {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            viewModel.showingMenu = false
                        }
                    
                    VStack(spacing: 0) {
                        // 1. Сортировать по алфавиту
                        MenuRow(
                            title: "Сортировать по алфавиту",
                            icon: "arrow.up.arrow.down",
                            action: {
                                viewModel.sortByName()
                                viewModel.showingMenu = false
                            }
                        )
                        
                        Divider()
                        
                        // 2. Поделиться
                        MenuRow(
                            title: "Поделиться",
                            icon: "square.and.arrow.up",
                            action: {
                                viewModel.shareList()
                                viewModel.showingMenu = false
                            }
                        )
                        
                        Divider()
                        
                        // 3. Снять отметки со всех товаров
                        MenuRow(
                            title: "Снять отметки со всех товаров",
                            icon: "arrow.triangle.2.circlepath",
                            action: {
                                viewModel.uncheckAll()
                                viewModel.showingMenu = false
                            }
                        )
                        
                        Divider()
                        
                        // 4. Удалить купленные товары
                        MenuRow(
                            title: "Удалить купленные товары",
                            icon: "trash",
                            isDestructive: true,
                            action: {
                                viewModel.clearPurchased()
                                viewModel.showingMenu = false
                            }
                        )
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .frame(width: 280)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                }
            }
        )
    }
}

// MARK: - Preview
#Preview {
    // Создаем интерактивное превью с работающим SwiftData
    struct InteractivePreview: View {
        @State private var navigationPath = NavigationPath()
        
        var body: some View {
            NavigationStack(path: $navigationPath) {
                // Используем preview список из моков
                GroceryListView(shoppingList: ShoppingList.preview)
            }
        }
    }
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    
    do {
        let container = try ModelContainer(for: ShoppingList.self, configurations: config)
        
        // Добавляем preview данные в контекст
        let previewList = ShoppingList.preview
        container.mainContext.insert(previewList)
        
        return InteractivePreview()
            .modelContainer(container)
    } catch {
        return Text("Ошибка загрузки превью: \(error.localizedDescription)")
            .padding()
    }
}
