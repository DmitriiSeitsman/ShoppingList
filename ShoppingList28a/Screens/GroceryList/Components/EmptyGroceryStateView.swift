import SwiftUI

struct EmptyGroceryStateView: View {
    let onAddItem: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image("ImageStorysetScreen")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 200)
            
            VStack(spacing: 8) {
                Text("Давайте спланируем покупки!")
                    .font(.title3)
                    .fontWeight(.bold)
                Text("Начните добавлять товары")
                    .font(.appBody)
                    .foregroundColor(.gray)
            }
            .multilineTextAlignment(.center)
            
            Spacer()
            
            PrimaryButton(title: "Добавить товар", isActive: true, action: onAddItem)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
        }
    }
}

#Preview {
    EmptyGroceryStateView(onAddItem: {})
}
