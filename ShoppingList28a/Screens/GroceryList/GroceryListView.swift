import SwiftUI
import SwiftData
import Combine

struct GroceryListView: View {
    // MARK: - Dependencies
    @ObservedObject var viewModel: GroceryListViewModel
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - State
    @State private var showDeleteAllPurchasedAlert = false
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: Header
            GroceryListTopBar(
                listName: viewModel.shoppingList.name,
                onBack: {
                    viewModel.saveContext()
                    viewModel.objectWillChange.send()
                    router.pop()
                },
                onMenu: { viewModel.showingMenu = true }
            )
            
            // MARK: Search
            SearchBarView(searchText: $viewModel.searchText)
                .padding(.vertical, 12)
                .background(Color.slBackground)
            
            // MARK: Content
            let trimmedText = viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            let hasSearch = !trimmedText.isEmpty
            let itemsToShow = viewModel.filteredItems
            
            if itemsToShow.isEmpty {
                if hasSearch {
                    VStack(spacing: 8) {
                        Spacer()
                        VStack(spacing: 6) {
                            Image(systemName: "magnifyingglass.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 64, height: 64)
                                .foregroundColor(.secondary)
                                .padding(.bottom, 8)
                            Text("Ничего не найдено")
                                .font(.appBody)
                                .foregroundColor(.secondary)
                            Text("Попробуйте изменить запрос")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.slBackground)
                    .ignoresSafeArea()
                    .transition(.opacity)
                } else {
                    EmptyGroceryStateView(showingAddItem: $viewModel.showingAddItem)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                GroceryItemsList(
                    items: itemsToShow,
                    list: viewModel.shoppingList,
                    purchasedCount: itemsToShow.filter(\.isPurchased).count,
                    onAddItem: { viewModel.showingAddItem = true },
                    onDeleteAllPurchased: { showDeleteAllPurchasedAlert = true },
                    onEditList: { viewModel.showingMenu = true }
                )
            }
            
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.showingAddItem) {
            AddItemView(shoppingList: viewModel.shoppingList)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .background(Color.slBackground.ignoresSafeArea())
        .overlay(menuOverlay)
        .alert("Удаление купленных товаров",
               isPresented: $showDeleteAllPurchasedAlert) {
            Button("Отменить", role: .cancel) {}
            Button("Удалить", role: .destructive) {
                viewModel.clearPurchased()
            }
        } message: {
            Text("Вы действительно хотите удалить все купленные товары?")
        }
    }
    
    // MARK: - Menu Overlay
    @ViewBuilder
    private var menuOverlay: some View {
        if viewModel.showingMenu {
            ZStack(alignment: .topTrailing) {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeOut) {
                            viewModel.showingMenu = false
                        }
                    }

                VStack(spacing: 0) {
                    MenuRow(
                        title: viewModel.sortOrder == .name
                            ? "Сортировать по алфавиту"
                            : "Сортировать по алфавиту",
                        icon: "arrow.up.arrow.down",
                        iconColor: viewModel.sortOrder == .name ? .slRedSystem : .primary,
                        action: {
                            viewModel.toggleSortOrder()
                            viewModel.showingMenu = false
                        }
                    )

                    Divider()

                    MenuRow(
                        title: "Поделиться",
                        icon: "square.and.arrow.up",
                        action: {
                            viewModel.shareList()
                            viewModel.showingMenu = false
                        }
                    )

                    Divider()

                    MenuRow(
                        title: "Снять отметки со всех товаров",
                        icon: "arrow.triangle.2.circlepath",
                        action: {
                            viewModel.uncheckAll()
                            viewModel.showingMenu = false
                        }
                    )

                    Divider()

                    MenuRow(
                        title: "Удалить купленные товары",
                        icon: "trash",
                        isDestructive: true,
                        action: {
                            showDeleteAllPurchasedAlert = true
                            viewModel.showingMenu = false
                        }
                    )
                }
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 10)
                .frame(width: 260)
                .padding(.top, 60)
                .padding(.trailing, 16)
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.spring(), value: viewModel.showingMenu)
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: ShoppingList.self,
            GroceryItem.self,
            configurations: config
        )
        let context = container.mainContext
        let list = ShoppingList(name: "Продукты на неделю")
        let items = [
            GroceryItem(name: "Молоко", isPurchased: false, quantity: 1, unit: "л", list: list),
            GroceryItem(name: "Хлеб", isPurchased: true, quantity: 1, unit: "шт", list: list),
            GroceryItem(name: "Яйца", isPurchased: false, quantity: 10, unit: "шт", list: list)
        ]
        
        list.items = items
        context.insert(list)
        items.forEach { context.insert($0) }
        
        let viewModel = GroceryListViewModel(shoppingList: list, modelContext: context)
        
        return GroceryListView(viewModel: viewModel)
            .environmentObject(Router())
            .modelContainer(container)
    } catch {
        return Text("Ошибка превью: \(error.localizedDescription)")
    }
}
