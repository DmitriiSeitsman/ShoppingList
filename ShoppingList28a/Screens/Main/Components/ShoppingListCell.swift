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

#Preview {
  VStack(spacing: 16) {
    ForEach(ShoppingList.previewArray) { list in
      ShoppingListCell(list: list)
    }
  }
  .padding(.horizontal, 16)
}
