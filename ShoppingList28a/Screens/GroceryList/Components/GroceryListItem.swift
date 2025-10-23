import SwiftUI
import SwiftData

struct GroceryListItem: View {
  @Binding var item: GroceryItem
  var onDelete: () -> Void = {}
  var onFlag: () -> Void = {}

  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Toggle(item.name, isOn: $item.isPurchased)
          .toggleStyle(.checkbox)
        Spacer()
        Text("\(item.quantity) шт.")
      }
      .padding(.horizontal, 16)
      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        Button(action: onDelete) {
          Image(systemName: "trash")
        }
        .tint(.slRedSystem)
        Button(action: onFlag) {
          Image(systemName: "square.and.pencil")
        }
        .tint(.slGreySystem)
      }
      Divider()
    }
    .listRowSeparator(.hidden)
    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
  }
}

#Preview("two items") {
    PreviewHost()
}

private struct PreviewHost: View {
    private let list = ShoppingList.preview

    var body: some View {
        List {
            ForEach(list.items, id: \.name) { item in
                GroceryListItem(
                    item: .constant(item),
                    onDelete: {},
                    onFlag: {}
                )
            }
        }
    }
}
