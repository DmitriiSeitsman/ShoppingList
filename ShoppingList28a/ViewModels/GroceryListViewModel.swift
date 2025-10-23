import SwiftData
import SwiftUI
import Combine

@MainActor
final class GroceryListViewModel: ObservableObject {
    // MARK: - Published
    @Published var searchText: String = ""
    @Published private(set) var filteredItems: [GroceryItem] = []
    @Published var showingAddItem: Bool = false
    @Published var showingMenu: Bool = false
    @Published var sortOrder: SortOrder = .dateAdded

    // MARK: - Properties
    let shoppingList: ShoppingList
    private let modelContext: ModelContext
    private var cancellables = Set<AnyCancellable>()
    private var originalOrder: [GroceryItem] = []

    enum SortOrder {
        case name
        case dateAdded
    }

    // MARK: - Init
    init(shoppingList: ShoppingList, modelContext: ModelContext) {
        self.shoppingList = shoppingList
        self.modelContext = modelContext
        self.originalOrder = shoppingList.items

        setupSearchPipeline()
        applyFilters()
    }

    // MARK: - Combine Search
    private func setupSearchPipeline() {
        $searchText
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }

    // MARK: - Filtering Logic
    private func applyFilters() {
        let baseItems = shoppingList.items
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        let searched: [GroceryItem] = trimmed.isEmpty
            ? baseItems
            : baseItems.filter {
                $0.name.localizedCaseInsensitiveContains(trimmed) ||
                $0.unit.localizedCaseInsensitiveContains(trimmed)
            }

        switch sortOrder {
        case .name:
            filteredItems = searched.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        case .dateAdded:
            filteredItems = searched
        }
    }

    // MARK: - Actions
    func togglePurchased(for item: GroceryItem) {
        item.isPurchased.toggle()
        saveContext()
    }

    func addItem(_ item: GroceryItem) {
        item.list = shoppingList
        modelContext.insert(item)
        shoppingList.items.append(item)
        saveContext()
        applyFilters()
    }

    func deleteItem(_ item: GroceryItem) {
        modelContext.delete(item)
        saveContext()
        applyFilters()
    }

    func clearPurchased() {
        for item in shoppingList.items where item.isPurchased {
            modelContext.delete(item)
        }
        saveContext()
        applyFilters()
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
        applyFilters()
    }

    func uncheckAll() {
        for item in shoppingList.items where item.isPurchased {
            item.isPurchased = false
        }
        saveContext()
        applyFilters()
    }

    func shareList() {
        print("Share \(shoppingList.name)")
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
