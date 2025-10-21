import SwiftUI

struct GroceryListBottomBarRow: View {
    let purchasedCount: Int
    let onEdit: () -> Void
    let onDeleteAll: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Верхняя линия (если нужна)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(UIColor.separator))
                .frame(maxWidth: .infinity)
            
            HStack {
                Spacer()
                
                Text("\(purchasedCount) шт.")
                    .font(.appBody)
                    .fontWeight(.semibold)
                    .foregroundColor(.slBlackFontsMain)
                    .padding(.leading, 16)
                
                HStack(spacing: 0) {
                    
                    Button(action: onEdit) {
                        Image("IconSysCreate")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .frame(width: 52, height: 52)
                            .background(Color.slGreySystem)
                    }
                    
                    Button(action: onDeleteAll) {
                        Image("IconSysTrash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .frame(width: 52, height: 52)
                            .background(Color.slRedSystem)
                    }
                }
                .padding(.trailing, 0)
            }
            .frame(height: 52)
            .background(Color.clear)
            
            // Нижняя линия — разделитель между BottomBar и контентом под ним (PrimaryButton)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(UIColor.separator))
                .frame(maxWidth: .infinity)
        }
        .background(Color.clear)
    }
}

#Preview {
    VStack(spacing: 0) {
        // Bottom bar с разделительной линией снизу
        GroceryListBottomBarRow(
            purchasedCount: 2,
            onEdit: { print("Редактировать нажато") },
            onDeleteAll: { print("Удалить нажато") }
        )
    }
}
