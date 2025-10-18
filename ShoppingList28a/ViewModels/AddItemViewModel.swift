import SwiftUI
import Combine

final class AddItemViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var quantity: String = ""
    @Published var unit: String = "шт"
    @Published var nameError: Bool = false
    @Published var nameErrorText: String?
    @Published var quantityError: Bool = false
    @Published var quantityErrorText: String?

    let availableUnits = ["шт", "кг", "г", "л", "мл"]

    func createItem(items: [GroceryItem]) -> GroceryItem? {
        let trimmedName = name.trimmingCharacters(in: .whitespaces).lowercased()
        nameError = false
        nameErrorText = nil
        quantityError = false
        quantityErrorText = nil

        guard !trimmedName.isEmpty else {
            nameError = true
            nameErrorText = "Введите название товара"
            return nil
        }

        if items.contains(where: { $0.name.lowercased() == trimmedName }) {
            nameError = true
            nameErrorText = "Товар с таким названием уже существует"
            return nil
        }

        guard let quantityValue = Int(quantity), !quantity.isEmpty else {
            quantityError = true
            quantityErrorText = "Введите количество"
            return nil
        }

        return GroceryItem(name: name, isPurchased: false, quantity: quantityValue, unit: unit)
    }

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
