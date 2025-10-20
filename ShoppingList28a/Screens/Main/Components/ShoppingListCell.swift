import SwiftData
import SwiftUI

struct ShoppingListCell: View {
  let list: ShoppingList

  var body: some View {
    HStack(spacing: 16) {
      // Иконка списка
      Image(systemName: "cart.fill")
        .imageScale(.large)
        .foregroundColor(.blue)
        .frame(width: 48, height: 48)
        .background(Color.blue.opacity(0.1))
        .clipShape(Circle())

      // Название списка
      Text(list.name)
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundColor(.primary)
        .lineLimit(1)
        .truncationMode(.tail)

      Spacer()

      // Счетчик купленных товаров справа
      HStack(spacing: 4) {
        Text("\(list.purchasedCount)")
          .font(.body)
          .fontWeight(.regular)
          .foregroundColor(.primary)

        Text("/")
          .font(.body)
          .fontWeight(.regular)
          .foregroundColor(.primary)

        Text("\(list.items.count)")
          .font(.body)
          .fontWeight(.semibold)
          .foregroundColor(.primary)
      }
    }
    .padding(.vertical, 8)
    .padding(.horizontal, 16)
    .frame(height: 84)
  }
}

// MARK: - Preview with simplified model

// Создаем упрощенную структуру только для превью
struct PreviewShoppingList {
  let id = UUID()
  let name: String
  let items: [GroceryItem]
  var purchasedCount: Int { items.filter { $0.isPurchased }.count }
}

#Preview {
  // Создаем тестовые данные без SwiftData
  let previewList1 = PreviewShoppingList(
    name: "Очень длинное название списка покупок на всю неделю вперед",
    items: [
      GroceryItem(name: "Хлеб", isPurchased: true, quantity: 1),
      GroceryItem(name: "Молоко", isPurchased: false, quantity: 2),
      GroceryItem(name: "Яйца", isPurchased: false, quantity: 10),
      GroceryItem(name: "Сыр", isPurchased: true, quantity: 1),
    ]
  )

  let previewList2 = PreviewShoppingList(
    name: "Техника",
    items: [
      GroceryItem(name: "Наушники", isPurchased: false, quantity: 1),
      GroceryItem(name: "Зарядка", isPurchased: true, quantity: 2),
    ]
  )

  return VStack(spacing: 16) {
    // Используем адаптер для превью-структуры
    PreviewShoppingListCellAdapter(list: previewList1)
    PreviewShoppingListCellAdapter(list: previewList2)
  }
  .padding(.horizontal, 16)
}

// Адаптер для отображения превью-структуры
struct PreviewShoppingListCellAdapter: View {
  let list: PreviewShoppingList

  var body: some View {
    HStack(spacing: 16) {
      Image(systemName: "cart.fill")
        .imageScale(.large)
        .foregroundColor(.blue)
        .frame(width: 48, height: 48)
        .background(Color.blue.opacity(0.1))
        .clipShape(Circle())

      Text(list.name)
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundColor(.primary)
        .lineLimit(1)
        .truncationMode(.tail)

      Spacer()

      HStack(spacing: 4) {
        Text("\(list.purchasedCount)")
          .font(.body)
          .fontWeight(.regular)
          .foregroundColor(.primary)

        Text("/")
          .font(.body)
          .fontWeight(.regular)
          .foregroundColor(.primary)

        Text("\(list.items.count)")
          .font(.body)
          .fontWeight(.semibold)
          .foregroundColor(.primary)
      }
    }
    .padding(.vertical, 8)
    .padding(.leading, 16)
    .padding(.trailing, 16)
    .background(Color.slFramesBackground)
    .cornerRadius(16)
    .frame(height: 84)
  }
}
