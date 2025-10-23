import SwiftData
import SwiftUI

struct MainView: View {
    @EnvironmentObject private var router: Router
    @Environment(\.modelContext) private var modelContext

    @Query(sort: [SortDescriptor(\ShoppingList.createdAt, order: .reverse)])
    private var lists: [ShoppingList]

    enum SortOption: CaseIterable { case name, date, none }
    @State private var sortBy: SortOption = .none

    private var sortedLists: [ShoppingList] {
        switch sortBy {
        case .name:
            return lists.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        case .date:
            return lists.sorted { $0.createdAt < $1.createdAt }
        case .none:
            return lists
        }
    }

    var body: some View {
        VStack {
            ShoppingListsList(
                lists: sortedLists,
                sortBy: sortBy,
                onSelect: { router.push(.storySet($0)) },
                onDelete: { list in
                    modelContext.delete(list)
                    saveContext()
                },
                onDuplicate: { original in
                    let copy = original.copy()
                    modelContext.insert(copy)
                    saveContext()
                },
                onEdit: { list in
                    router.push(.editList(list))
                }
            )

            Spacer()

            PrimaryButton(title: "Создать список") {
                router.push(.createList)
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 12)
        .padding(.bottom, 20)
        .background(.slBackground)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            TopToolbar(sortBy: $sortBy)
        }
    }

    // MARK: - Helpers
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("❌ Save error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: [ShoppingList.self, GroceryItem.self], inMemory: true)
}
