import SwiftData
import SwiftUI
import Combine

@MainActor
final class GroceryListViewModel: ObservableObject {
    // MARK: - Published
    @Published var searchText: String = ""
    @Published var showingAddItem: Bool = false
    @Published var showingMenu: Bool = false
    @Published var sortOrder: SortOrder = .dateAdded

    // MARK: - Properties
    let shoppingList: ShoppingList
    private let modelContext: ModelContext
    private var originalOrder: [GroceryItem] = []

    enum SortOrder {
        case name
        case dateAdded
    }

    // MARK: - Computed Properties
    var filteredItems: [GroceryItem] {
        let baseItems = searchText.isEmpty
            ? shoppingList.items
            : shoppingList.items.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }

        switch sortOrder {
        case .name:
            return baseItems.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        case .dateAdded:
            return baseItems
        }
    }

    // MARK: - Init
    init(shoppingList: ShoppingList, modelContext: ModelContext) {
        self.shoppingList = shoppingList
        self.modelContext = modelContext
        self.originalOrder = shoppingList.items
    }

    // MARK: - Actions

    func togglePurchased(for item: GroceryItem) {
        item.isPurchased.toggle()
        saveContext()
    }

    func addItem(_ item: GroceryItem) {
        item.list = shoppingList
        modelContext.insert(item)
        shoppingList.items.append(item) // сохраняем в конец списка
        saveContext()
    }

    func deleteItem(_ item: GroceryItem) {
        modelContext.delete(item)
        saveContext()
    }

    func clearPurchased() {
        for item in shoppingList.items where item.isPurchased {
            modelContext.delete(item)
        }
        saveContext()
    }

    func toggleSortOrder() {
        if sortOrder == .name {
            sortOrder = .dateAdded
            shoppingList.items = originalOrder
        } else {
            originalOrder = shoppingList.items
            sortOrder = .name
            shoppingList.items.sort {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        }
        saveContext()
    }

    func uncheckAll() {
        for item in shoppingList.items where item.isPurchased {
            item.isPurchased = false
        }
        saveContext()
    }

    func shareList() {
        // TODO: добавить функционал экспорта / шеринга
    }

    // MARK: - Private
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("❌ Ошибка сохранения контекста: \(error.localizedDescription)")
        }
    }
}
