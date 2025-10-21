import SwiftData
import SwiftUI

@Model
final class ShoppingList {
    var name: String
    var createdAt: Date
    var itemsData: Data  // Храним как Data
    
    var iconName: String
    var iconColor: String

    // Вычисляемое свойство для работы с GroceryItem
    var items: [GroceryItem] {
        get {
            decodeItems(from: itemsData)
        }
        set {
            itemsData = ShoppingList.encodeItems(newValue)
        }
    }

    init(name: String, createdAt: Date = .now, iconName: String = "iconCart", iconColor: String = "slYellowAdditional", items: [GroceryItem] = []) {
        self.name = name
        self.createdAt = createdAt
        self.itemsData = Self.encodeItems(items)
        self.iconName = iconName
        self.iconColor = iconColor
    }

    var purchasedCount: Int {
        items.filter { $0.isPurchased }.count
    }

    // Ручное кодирование в JSON-совместимый формат
    private static func encodeItems(_ items: [GroceryItem]) -> Data {
        let dictArray = items.map { item in
            [
                "name": item.name,
                "isPurchased": item.isPurchased,
                "quantity": item.quantity
            ]
        }

        do {
            return try JSONSerialization.data(withJSONObject: dictArray)
        } catch {
            return Data()
        }
    }

    // Ручное декодирование из JSON-совместимого формата
    private func decodeItems(from data: Data) -> [GroceryItem] {
        do {
            guard
                let dictArray = try JSONSerialization.jsonObject(with: data)
                    as? [[String: Any]]
            else {
                return []
            }

            return dictArray.compactMap { dict in
                guard let name = dict["name"] as? String,
                    let isPurchased = dict["isPurchased"] as? Bool,
                    let quantity = dict["quantity"] as? Int
                else {
                    return nil
                }

                // Создаем новый GroceryItem - id сгенерируется автоматически
                return GroceryItem(
                    name: name,
                    isPurchased: isPurchased,
                    quantity: quantity
                )
            }
        } catch {
            return []
        }
    }
}
