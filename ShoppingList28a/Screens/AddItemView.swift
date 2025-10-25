import SwiftUI
import SwiftData

struct AddItemView: View {
    // MARK: - Environment
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    // MARK: - ViewModel
    @StateObject private var viewModel = AddItemViewModel()

    // MARK: - Properties
    let shoppingList: ShoppingList
    var editingItem: GroceryItem?

    private var isEditing: Bool { editingItem != nil }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            header
            form
            Spacer()
        }
        .background(Color.slBackground)
        .animation(.easeInOut(duration: 0.2), value: viewModel.name)
        .onAppear {
            if let editingItem {
                viewModel.name = editingItem.name
                viewModel.quantity = String(editingItem.quantity)
                viewModel.unit = editingItem.unit
            }
        }
        .onDisappear { viewModel.reset() }
        .hideKeyboardOnTap()
    }
}

// MARK: - UI Subviews
private extension AddItemView {
    var header: some View {
        HStack {
            // MARK: Cancel button
            Button("Отменить") {
                viewModel.reset()
                dismiss()
            }
            .font(.appBody)
            .foregroundColor(.slGrey)

            Spacer()

            // MARK: Title
            Text(isEditing ? "Редактирование товара" : "Создание товара")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.slBlackFontsTitle)

            Spacer()

            Button("Готово") {
                if isEditing {
                    updateItem()
                } else {
                    addNewItem()
                }
            }
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(isFormValid ? .slTurquoise : .slGrey)
            .disabled(!isFormValid)
        }
        .padding(.horizontal, 16)
        .padding(.top, 21)
    }

    var form: some View {
        VStack(spacing: 20) {
            BaseTextField(
                placeholder: "Название товара",
                text: $viewModel.name,
                isError: viewModel.nameError,
                errorText: viewModel.nameErrorText
            )
            .onChange(of: viewModel.name) { _, newValue in
                let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                viewModel.nameError = false
                viewModel.nameErrorText = nil
                if trimmed.isEmpty {
                    viewModel.nameError = true
                    viewModel.nameErrorText = "Введите название товара"
                } else if shoppingList.items.contains(where: { $0.name.lowercased() == trimmed.lowercased() && (isEditing ? $0 != editingItem : true) }) {
                    viewModel.nameError = true
                    viewModel.nameErrorText = "Такой товар уже есть"
                }
            }

            HStack(alignment: .top, spacing: -12) {
                BaseTextField(
                    placeholder: "Количество",
                    text: $viewModel.quantity,
                    isError: viewModel.quantityError,
                    errorText: viewModel.quantityErrorText
                )
                .keyboardType(.numberPad)
                .frame(maxWidth: .infinity)
                .onChange(of: viewModel.quantity) { _, newValue in
                      viewModel.quantityError = false
                      viewModel.quantityErrorText = nil
                      if Int(newValue) == nil || Int(newValue) ?? 0 <= 0 {
                          viewModel.quantityError = true
                          viewModel.quantityErrorText = "Введите количество"
                      }
                  }

                ZStack {
                    Text("Ед.изм.:")
                        .font(.appBody)
                        .foregroundColor(.slGreySystem)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .frame(height: 54)
                        .background(Color.slFramesBackground)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)

                    Menu {
                        ForEach(viewModel.availableUnits, id: \.self) { unit in
                            Button(unit) {
                                viewModel.unit = unit
                            }
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text(viewModel.unit)
                                .font(.appBody)
                                .foregroundColor(.slTurquoise)
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.system(size: 17))
                                .foregroundColor(.slTurquoise)
                        }
                        .padding(.horizontal, 32)
                    }
                }
            }
        }
    }

    var isFormValid: Bool {
        let trimmedName = viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedName.isEmpty &&
               !viewModel.quantity.isEmpty &&
               Int(viewModel.quantity) != nil &&
               Int(viewModel.quantity)! > 0 &&
               !viewModel.nameError &&
               !viewModel.quantityError
    }}

// MARK: - Save Logic
private extension AddItemView {
    func addNewItem() {
        guard let newItem = viewModel.createItem(for: shoppingList, in: modelContext) else {
            return
        }
        dismiss()
    }

    func updateItem() {
        guard let editingItem else { return }
        guard viewModel.updateItem(editingItem, in: modelContext, for: shoppingList) else {
            return 
        }
        dismiss()
    }
}

// MARK: - Preview
#Preview("Создание") {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ShoppingList.self, GroceryItem.self, configurations: config)
        let context = container.mainContext

        let list = ShoppingList(name: "Продукты", iconName: "IconCart", iconColor: "slYellowAdditional")
        context.insert(list)

        return AddItemView(shoppingList: list)
            .modelContainer(container)
    } catch {
        return Text("Ошибка превью: \(error.localizedDescription)")
    }
}

#Preview("Редактирование") {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ShoppingList.self, GroceryItem.self, configurations: config)
        let context = container.mainContext

        let list = ShoppingList(name: "Продукты", iconName: "IconCart", iconColor: "slYellowAdditional")
        context.insert(list)

        let item = GroceryItem(name: "Молоко", isPurchased: false, quantity: 2, unit: "л", list: list)
        context.insert(item)

        return AddItemView(shoppingList: list, editingItem: item)
            .modelContainer(container)
    } catch {
        return Text("Ошибка превью: \(error.localizedDescription)")
    }
}
