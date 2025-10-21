import SwiftUI

struct ShoppingListsList: View {
  @Binding var lists: [ShoppingList]
  @State var sortBy: MainView.SortOption
  @State private var pendingDeleteIndex: Int?
  @State private var showDeleteConfirm = false

  var body: some View {
    if lists.isEmpty {
      EmptyStateView()
    } else {
      List {
        ForEach(
          lists.sorted(by: { aaa, bbb in
            switch sortBy {
            case .name:
              return aaa.name < bbb.name
            case .date:
              return aaa.createdAt < bbb.createdAt
            case .none:
              return false
            }
          }).indices, id: \.self
        ) { index in
          let item = lists[index]
          ShoppingListCell(list: item)
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
              Button {
                pendingDeleteIndex = index
                showDeleteConfirm = true
              } label: {
                Image(systemName: "trash")
              }.tint(.slRedSystem)

              Button {
                let item = lists[index]
                lists.append(item)
              } label: {
                Image(systemName: "plus.square.on.square")
              }.tint(.slOrangeSystem)

              Button {

              } label: {
                Image(systemName: "square.and.pencil")
              }.tint(.slGreySystem)

            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .background(Color.slFramesBackground)
        }
      }
      .scrollContentBackground(.hidden)
      .contentMargins(.vertical, 0)
      .listRowSpacing(12)
      .listStyle(.insetGrouped)
      .alert(
        "Удаление списка",
        isPresented: $showDeleteConfirm,
        presenting: pendingDeleteIndex
      ) { idx in
        Button("Удалить", role: .destructive) { lists.remove(at: idx) }
        Button("Отмена", role: .cancel) {}
      } message: { _ in
        Text("Вы действительно хотите удалить список?")
      }
    }
  }
}

#Preview("Data") {
  @State @Previewable var lists = ShoppingList.previewArray
  ShoppingListsList(lists: $lists, sortBy: .name)
}

#Preview("Empty") {
  @State @Previewable var lists = [ShoppingList]()
  ShoppingListsList(lists: $lists, sortBy: .name)
}
