import SwiftUI

struct EmptyGroceryStateView: View {
    let listName: String
    let onBack: () -> Void
    @Binding var items: [GroceryItem]
    
    @State private var showingAddItem = false
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Button(action: onBack) {
                    Image("IconChevronLeft")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.slBlackFontsTitle)
                        .frame(width: 8, height: 16)
                        .padding(6)
                        .contentShape(Rectangle())
                }
                .frame(width: 28, height: 44)
                .buttonStyle(.plain)
                
                Text(listName)
                    .font(.appHeadline)
                    .foregroundColor(.slBlackFontsTitle)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.slGrey)
                    
                    TextField("Поиск", text: $searchText)
                        
                        .font(.appBody)
                        .foregroundColor(.slBlackFontsMain)
                }
                .padding(.horizontal, 8)
                .frame(height: 38)
                .background(Color.slFramesBackground)
                .cornerRadius(10)
            }
            .padding(.horizontal, 16)
            .frame(height: 58)
            
            Spacer()
            
            Image("ImageStorysetScreen")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 200)
            
            VStack(spacing: 8) {
                Text("Давайте спланируем покупки!")
                    .font(.title3)
                    .foregroundColor(.slBlackFontsMain)
                Text("Начните добавлять товары")
                    .font(.appBody)
                    .foregroundColor(.slBlackFontsMain)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            PrimaryButton(title: "Добавить товар", isActive: true) {
                showingAddItem = true
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(Color.slBackground.ignoresSafeArea())
        
        .sheet(isPresented: $showingAddItem) {
            AddItemView(items: $items)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    EmptyGroceryStateView(
        listName: "Покупки на неделю",
        onBack: {},
        items: .constant([
            GroceryItem(name: "Молоко", isPurchased: false, quantity: 1, unit: "л")
        ])
    )
}
