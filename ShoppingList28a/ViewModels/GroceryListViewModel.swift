import Combine
import SwiftData
import SwiftUI

final class GroceryListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var searchText: String = ""
    @Published var showingAddItem: Bool = false
    @Published var showingMenu: Bool = false
    @Published var sortOrder: SortOrder = .name
    @Published var refreshTrigger = UUID()

    // MARK: - Properties
    let shoppingList: ShoppingList
    private let modelContext: ModelContext

    enum SortOrder {
        case name, dateAdded
    }

    // MARK: - Computed Properties
    var filteredItems: [GroceryItem] {
        let items =
            searchText.isEmpty
            ? shoppingList.items
            : shoppingList.items.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }

        switch sortOrder {
        case .name:
            return items.sorted { $0.name < $1.name }
        case .dateAdded:
            return items
        }
    }

    // MARK: - Initialization
    init(shoppingList: ShoppingList, modelContext: ModelContext? = nil) {
        self.shoppingList = shoppingList

        // Используем переданный context или создаем новый
        if let context = modelContext {
            self.modelContext = context
        } else {
            // Для превью создаем временный контейнер с обработкой ошибок
            do {
                self.modelContext = ModelContext(
                    try ModelContainer(for: ShoppingList.self)
                )
            } catch {
                // В случае ошибки создаем пустой контекст (fallback)
                fatalError("Failed to create ModelContainer: \(error)")
            }
        }
    }

    // MARK: - Actions
    func togglePurchased(for item: GroceryItem) {
        // Создаем новый массив с обновленным элементом
        var updatedItems = shoppingList.items
        if let index = updatedItems.firstIndex(where: { $0.id == item.id }) {
            var updatedItem = updatedItems[index]
            updatedItem.isPurchased.toggle()
            updatedItems[index] = updatedItem

            // Обновляем список
            shoppingList.items = updatedItems

            // Триггерим обновление UI
            refreshTrigger = UUID()
        }
    }

    func deleteItem(_ item: GroceryItem) {
        shoppingList.items.removeAll { $0.id == item.id }
        refreshTrigger = UUID()
    }

    func sortByName() {
        sortOrder = .name
        shoppingList.items.sort { $0.name < $1.name }
        refreshTrigger = UUID()
    }

    func sortByDateAdded() {
        sortOrder = .dateAdded
        refreshTrigger = UUID()
    }

    func clearPurchased() {
        shoppingList.items.removeAll { $0.isPurchased }
        refreshTrigger = UUID()
    }

    func updateItems() {
        refreshTrigger = UUID()
    }

    func uncheckAll() {}

    func shareList() {}
}
