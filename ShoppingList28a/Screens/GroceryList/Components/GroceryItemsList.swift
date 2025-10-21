import SwiftUI

struct GroceryItemsList: View {
    @Binding var items: [GroceryItem]
    let purchasedCount: Int
    let onAddItem: () -> Void
    let onDelete: (GroceryItem) -> Void
    let onDeleteAllPurchased: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(items.indices, id: \.self) { index in
                    ZStack {
                        GroceryListItem(
                            item: $items[index],
                            onDelete: { onDelete(items[index]) },
                            onFlag: {
                                // исправлено: корректная интерполяция
                                print("Редактировать товар: $$items[index].name)")
                            }
                        )
                        .foregroundColor(!items[index].isPurchased ? .slBlackFontsMain : .slGreyList)
                    }
                    // Закрываем встроенный Divider() внутри GroceryListItem, чтобы он не "ломал" линию
                    .overlay(
                        // захораниваем ту маленькую линию, которую кладёт сам GroceryListItem
                        Color.slBackground
                            .frame(height: 1),
                        alignment: .bottom
                    )
                    // Рисуем верхнюю границу только если это не первая строка
                    .overlay(alignment: .top) {
                        if index != items.startIndex {
                            Rectangle()
                                .foregroundColor(Color(UIColor.separator))
                                .frame(height: 1)
                                .frame(maxWidth: .infinity)
                        } else {
                            EmptyView()
                        }
                    }
                    .listRowBackground(Color.clear)         // фон строки прозрачный
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .onDelete { indexSet in items.remove(atOffsets: indexSet) }
                
                // Bottom bar — верхняя линия обязательна
                GroceryListBottomBarRow(
                    purchasedCount: purchasedCount,
                    onEdit: { print("Редактировать список") },
                    onDeleteAll: onDeleteAllPurchased
                )
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.slBackground)
            
            PrimaryButton(title: "Добавить товар", isActive: true, action: onAddItem)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
        }
    }
}

// MARK: - Preview
#Preview {
    // Упрощенная версия превью без State
    let items = [
        GroceryItem(name: "Молоко", isPurchased: false, quantity: 2, unit: "л"),
        GroceryItem(name: "Сыр", isPurchased: false, quantity: 2, unit: "кг"),
        GroceryItem(name: "Масло", isPurchased: false, quantity: 2, unit: "кг"),
        GroceryItem(name: "Хлеб", isPurchased: true, quantity: 1, unit: "шт")
    ]
    
    return GroceryItemsList(
        items: .constant(items),
        purchasedCount: 1,
        onAddItem: { print("Add item") },
        onDelete: { item in
            print("Delete item: \(item.name)")
        },
        onDeleteAllPurchased: {
            print("Delete all purchased items")
        }
    )
}
