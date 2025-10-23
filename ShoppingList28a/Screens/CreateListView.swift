import SwiftData
import SwiftUI

struct CreateListView: View {
    @EnvironmentObject private var router: Router
    @Environment(\.modelContext) private var modelContext

    // MARK: - Входные параметры
    var editingList: ShoppingList?

    // MARK: - State
    @State private var listTitle: String = ""
    @State private var selectedColor: Color?
    @State private var selectedIcon: String?

    private var isEditing: Bool { editingList != nil }
    private var isButtonActive: Bool {
        !listTitle.isEmpty && selectedColor != nil && selectedIcon != nil
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            headerView
            contentView

            PrimaryButton(title: isEditing ? "Сохранить" : "Создать", isActive: isButtonActive) {
                if isEditing {
                    updateList()
                } else {
                    createNewList()
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(Color.slBackground.ignoresSafeArea())
        .onAppear {
            if let editingList {
                listTitle = editingList.name
                selectedIcon = editingList.iconName
                selectedColor = Color(editingList.iconColor)
            }
        }
    }

    // MARK: - Header
    private var headerView: some View {
        HStack(spacing: 8) {
            Button { router.pop() } label: {
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

            Text(isEditing ? "Редактировать список" : "Создать список")
                .font(.appHeadline)
                .foregroundColor(.slBlackFontsTitle)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    // MARK: - Content
    private var contentView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                BaseTextField(
                    placeholder: "Введите название списка",
                    text: $listTitle,
                    isError: false,
                    errorText: nil
                )
                .padding(.top, 12)

                ColorGridView(
                    selectedColor: $selectedColor,
                    colors: ListUIConstants.availableColors
                )

                IconGridView(
                    selectedIcon: $selectedIcon,
                    icons: ListUIConstants.availableIcons,
                    selectionColor: selectedColor ?? .slGreyButton
                )
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 20)
        }
    }

    // MARK: - Logic

    private func createNewList() {
        guard let color = selectedColor, let icon = selectedIcon else { return }

        let newList = ShoppingList(
            name: listTitle,
            iconName: icon,
            iconColor: color.assetName ?? "slYellowAdditional"
        )

        modelContext.insert(newList)

        do {
            try modelContext.save()
            print("Список создан: \(newList.name)")
            router.pop()
        } catch {
            print("Ошибка при сохранении списка: \(error.localizedDescription)")
        }
    }

    private func updateList() {
        guard let editingList else { return }
        guard let color = selectedColor, let icon = selectedIcon else { return }

        editingList.name = listTitle
        editingList.iconName = icon
        editingList.iconColor = color.assetName ?? "slYellowAdditional"

        do {
            try modelContext.save()
            print("Список обновлён: \(editingList.name)")
            router.pop()
        } catch {
            print("Ошибка при обновлении списка: \(error.localizedDescription)")
        }
    }
}

#Preview("Создание") {
    CreateListView()
        .environmentObject(Router())
        .modelContainer(for: [ShoppingList.self, GroceryItem.self], inMemory: true)
}

#Preview("Редактирование") {
    let list = ShoppingList(
        name: "Продукты",
        iconName: "cart.fill",
        iconColor: "slBlueSystem"
    )

    return CreateListView(editingList: list)
        .environmentObject(Router())
        .modelContainer(for: [ShoppingList.self, GroceryItem.self], inMemory: true)
}
