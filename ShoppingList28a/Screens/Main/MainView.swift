import SwiftUI

struct MainView: View {
  enum SortOption: CaseIterable {
    case name, date, none
  }

  @State private var lists: [ShoppingList] = ShoppingList.previewArray
  @State private var sortBy: SortOption = .none

  var body: some View {
    VStack {
      ShoppingListsList(lists: $lists, sortBy: sortBy)
      Spacer()
      PrimaryButton(title: "Создать список") {}.padding(.horizontal, 16)
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
