import SwiftData
import SwiftUI

struct ShoppingListCell: View {
    @Bindable var list: ShoppingList
    
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
            .animation(.easeInOut(duration: 0.2), value: list.purchasedCount)
        }
        .padding(.vertical, 8)
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .background(Color.slFramesBackground)
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
    .modelContainer(for: [ShoppingList.self, GroceryItem.self], inMemory: true)
}
