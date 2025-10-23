import SwiftUI
import Combine
import SwiftData

@MainActor
final class AddItemViewModel: ObservableObject {
    // MARK: - Published properties
    @Published var name: String = ""
    @Published var quantity: String = ""
    @Published var unit: String = "шт"
    @Published var nameError: Bool = false
    @Published var nameErrorText: String?
    @Published var quantityError: Bool = false
    @Published var quantityErrorText: String?

    let availableUnits = ["шт", "кг", "г", "л", "мл"]

    // MARK: - Validation and creation
    func createItem(for list: ShoppingList, in context: ModelContext) -> GroceryItem? {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        nameError = false
        nameErrorText = nil
        quantityError = false
        quantityErrorText = nil

        // Проверка имени
        guard !trimmedName.isEmpty else {
            nameError = true
            nameErrorText = "Введите название товара"
            return nil
        }

        // Проверка на дубли
        if list.items.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) {
            nameError = true
            nameErrorText = "Такой товар уже есть"
            return nil
        }

        // Проверка количества
        guard let quantityValue = Int(quantity), quantityValue > 0 else {
            quantityError = true
            quantityErrorText = "Введите корректное количество"
            return nil
        }

        // Создание и привязка к списку
        let newItem = GroceryItem(
            name: trimmedName,
            isPurchased: false,
            quantity: quantityValue,
            unit: unit,
            list: list
        )

        context.insert(newItem)
        list.items.append(newItem)

        do {
            try context.save()
            print("✅ Сохранён товар \(trimmedName) в список \(list.name)")
            return newItem
        } catch {
            print("❌ Ошибка сохранения: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Reset
    func reset() {
        name = ""
        quantity = ""
        unit = "шт"
        nameError = false
        nameErrorText = nil
        quantityError = false
        quantityErrorText = nil
    }
}
