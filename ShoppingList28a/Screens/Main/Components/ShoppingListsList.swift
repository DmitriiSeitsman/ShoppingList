import SwiftUI

struct ShoppingListsList: View {
    var lists: [ShoppingList]
    var sortBy: MainView.SortOption
    var onSelect: ((ShoppingList) -> Void)?
    var onDelete: ((ShoppingList) -> Void)?
    var onDuplicate: ((ShoppingList) -> Void)?
    var onEdit: ((ShoppingList) -> Void)?

    @State private var pendingDeleteItem: ShoppingList?
    @State private var showDeleteConfirm = false

    var body: some View {
        if lists.isEmpty {
            VStack {
                Spacer(minLength: 88)
                EmptyStateView()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.slBackground)
        } else {
            let sorted: [ShoppingList] = {
                switch sortBy {
                case .name:
                    return lists.sorted {
                        $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                    }
                case .date:
                    return lists.sorted { $0.createdAt < $1.createdAt }
                }
            }()

            List {
                ForEach(sorted) { item in
                    Button {
                        onSelect?(item)
                    } label: {
                        ShoppingListCell(list: item)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {

                        // MARK: - Удалить
                        Button(role: .destructive) {
                            pendingDeleteItem = item
                            showDeleteConfirm = true
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.slRedSystem)

                        // MARK: - Дублировать
                        Button {
                            onDuplicate?(item)
                        } label: {
                            Image(systemName: "plus.square.on.square")
                        }
                        .tint(.slOrangeSystem)

                        // MARK: - Редактировать
                        Button {
                            onEdit?(item)
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                        .tint(.slGreySystem)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .background(Color.slFramesBackground)
                }
            }
            .scrollContentBackground(.hidden)
            .contentMargins(.vertical, 0)
            .listRowSpacing(12)
            .listStyle(.insetGrouped)
            .alert("Удаление списка", isPresented: $showDeleteConfirm, presenting: pendingDeleteItem) { item in
                Button("Удалить", role: .destructive) { onDelete?(item) }
                Button("Отмена", role: .cancel) {}
            } message: { _ in
                Text("Вы действительно хотите удалить список?")
            }
        }
    }
}

#Preview("Data") {
    @State @Previewable var lists = ShoppingList.previewArray
    ShoppingListsList(lists: lists, sortBy: .name)
}

#Preview("Empty") {
    @State @Previewable var lists = [ShoppingList]()
    ShoppingListsList(lists: lists, sortBy: .name)
}
