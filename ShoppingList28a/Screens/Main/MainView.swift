import SwiftUI

struct MainView: View {
    @EnvironmentObject private var router: Router
    
    enum SortOption: CaseIterable {
        case name, date, none
    }
    
    @State private var lists: [ShoppingList] = ShoppingList.previewArray
    @State private var sortBy: SortOption = .none
    
    var body: some View {
        VStack {
            ShoppingListsList(lists: $lists, sortBy: sortBy) { selectedList in
                router.push(.storySet(selectedList))
            }

            Spacer()

            PrimaryButton(title: "Создать список") {
                router.push(.createList)
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 12)
        .padding(.bottom, 20)
        .background(.slBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            TopToolbar(sortBy: $sortBy)
        }
    }
}

#Preview {
    MainView()
}
