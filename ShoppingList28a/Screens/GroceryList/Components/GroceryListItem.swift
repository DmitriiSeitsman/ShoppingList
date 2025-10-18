import SwiftUI
import SwiftData

struct GroceryListItem: View {
    @Bindable var item: ListItem
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
    @State private var items: [ListItem] = ListItem.mockArray

    var body: some View {
        List {
            ForEach(items.indices, id: \.self) { index in
                GroceryListItem(
                    item: items[index],
                    onDelete: { items.remove(at: index) },
                    onFlag: {
                        print("Edit \(items[index].name)")
                    }
                )
                .foregroundColor(!items[index].isPurchased ? .slBlackFontsMain : .slGreyList)
            }
            .onDelete { indexSet in
                items.remove(atOffsets: indexSet)
            }
        }
        .listStyle(.plain)
    }
}
