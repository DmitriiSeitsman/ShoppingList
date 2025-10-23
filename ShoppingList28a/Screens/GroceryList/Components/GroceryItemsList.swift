import SwiftUI
import SwiftData

struct GroceryItemsList: View {
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext

    @Query(sort: [SortDescriptor(\GroceryItem.name)])
    private var allItems: [GroceryItem]

    let list: ShoppingList
    let purchasedCount: Int
    let onAddItem: () -> Void
    let onDeleteAllPurchased: () -> Void
    let onEditList: () -> Void

    // MARK: - Init
    init(
        list: ShoppingList,
        purchasedCount: Int,
        onAddItem: @escaping () -> Void,
        onDeleteAllPurchased: @escaping () -> Void,
        onEditList: @escaping () -> Void
    ) {
        self.list = list
        self.purchasedCount = purchasedCount
        self.onAddItem = onAddItem
        self.onDeleteAllPurchased = onDeleteAllPurchased
        self.onEditList = onEditList
    }

    // MARK: - Computed filtered items
    private var items: [GroceryItem] {
        allItems.filter { $0.list?.persistentModelID == list.persistentModelID }
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
                    ForEach(items) { item in
                        GroceryListItem(
                            item: .constant(item),
                            onDelete: { deleteItem(item) },
                            onFlag: { print("✏️ Редактировать: \(item.name)") }
                        )
                        .listRowInsets(EdgeInsets())
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
    }

    // MARK: - Actions
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
            print("❌ Ошибка сохранения контекста: \(error.localizedDescription)")
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
