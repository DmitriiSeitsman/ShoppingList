import SwiftUI
import SwiftData

struct GroceryItemsList: View {
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext

    let items: [GroceryItem]
    let list: ShoppingList
    let purchasedCount: Int
    let onAddItem: () -> Void
    let onDeleteAllPurchased: () -> Void
    let onEditList: () -> Void

    @State private var editingItem: GroceryItem?

    // MARK: - Init
    init(
        items: [GroceryItem],
        list: ShoppingList,
        purchasedCount: Int,
        onAddItem: @escaping () -> Void,
        onDeleteAllPurchased: @escaping () -> Void,
        onEditList: @escaping () -> Void
    ) {
        self.items = items
        self.list = list
        self.purchasedCount = purchasedCount
        self.onAddItem = onAddItem
        self.onDeleteAllPurchased = onDeleteAllPurchased
        self.onEditList = onEditList
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            if items.isEmpty {
                Text("Нет товаров 😕")
                    .foregroundColor(.secondary)
                    .padding(.top, 40)
            } else {
                List {
                    ForEach(items, id: \.persistentModelID) { item in
                        GroceryListItem(
                            item: item,
                            onDelete: { deleteItem(item) },
                            onFlag: { startEditing(item) }
                        )
                    }
                    .background(.slBackground)
                }
                .listStyle(.plain)
            }

            Spacer()

            PrimaryButton(title: "Добавить товар", isActive: true, action: onAddItem)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
        }
        .sheet(item: $editingItem) { item in
            AddItemView(shoppingList: list, editingItem: item)
                .presentationDetents([.medium, .large])
        }
    }

    // MARK: - Actions
    private func startEditing(_ item: GroceryItem) {
        editingItem = item
    }

    private func deleteItem(_ item: GroceryItem) {
        modelContext.delete(item)
        saveContext()
    }

    private func deletePurchased() {
        items.filter { $0.isPurchased }.forEach(modelContext.delete)
        saveContext()
        onDeleteAllPurchased()
    }

    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Ошибка сохранения контекста: \(error.localizedDescription)")
        }
    }
}

#Preview {
    do {
        let container = try ModelContainer(
            for: ShoppingList.self, GroceryItem.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        let context = container.mainContext
        let list = ShoppingList(name: "Продукты")
        context.insert(list)

        let sampleItems = [
            GroceryItem(name: "Молоко", isPurchased: false, quantity: 2, unit: "л", list: list),
            GroceryItem(name: "Хлеб", isPurchased: true, quantity: 1, unit: "шт", list: list)
        ]
        sampleItems.forEach(context.insert)

        return GroceryItemsList(
            items: sampleItems,
            list: list,
            purchasedCount: sampleItems.filter { $0.isPurchased }.count,
            onAddItem: {},
            onDeleteAllPurchased: {},
            onEditList: {}
        )
        .modelContainer(container)
    } catch {
        fatalError("Ошибка превью: \(error)")
    }
}
