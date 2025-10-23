import SwiftUI

struct GroceryListTopBar: View {
    let listName: String
    let onBack: () -> Void
    let onMenu: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .foregroundColor(.primary)
            }
            
            Text(listName)
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
                .padding(.leading, 8)
            
            Spacer()
            
            Button(action: onMenu) {
                Image(systemName: "ellipsis.circle")
                    .imageScale(.large)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 12)
        .background(Color.slBackground)
    }
}

#Preview {
    VStack(spacing: 20) {
        // Короткое название
        GroceryListTopBar(
            listName: "Продукты",
            onBack: { print("Назад") },
            onMenu: { print("Меню") }
        )
        
        // Длинное название (проверка обрезки)
        GroceryListTopBar(
            listName: "Очень длинное название списка покупок на всю неделю",
            onBack: { print("Назад") },
            onMenu: { print("Меню") }
        )
        
        // Еще один вариант
        GroceryListTopBar(
            listName: "Хозтовары",
            onBack: { print("Назад") },
            onMenu: { print("Меню") }
        )
    }
}
