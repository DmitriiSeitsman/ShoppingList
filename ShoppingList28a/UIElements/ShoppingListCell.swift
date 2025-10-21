import SwiftUI
import SwiftData

struct ShoppingListCell: View {
    let list: ShoppingList

    var body: some View {
        HStack(spacing: 16) {
            // Иконка списка
            Image(list.iconName)
                .imageScale(.large)
                .frame(width: 48, height: 48)
                .background(Color(list.iconColor))
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
        .padding(.leading, 16)  // Отступ картинки от края ячейки
        .padding(.trailing, 16) // Отступ чисел от края ячейки
        .background(Color.slFramesBackground) // Фон ячейки
        .cornerRadius(16)
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
