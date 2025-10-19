import SwiftData
import SwiftUI

@Model
final class ShoppingList {
    var name: String
    var createdAt: Date
    var itemsData: Data  // Храним как Data

    // Вычисляемое свойство для работы с GroceryItem
    var items: [GroceryItem] {
        get {
            decodeItems(from: itemsData)
        }
        set {
            itemsData = ShoppingList.encodeItems(newValue)
        }
    }

    init(name: String, createdAt: Date = .now, items: [GroceryItem] = []) {
        self.name = name
        self.createdAt = createdAt
        self.itemsData = Self.encodeItems(items)
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

    static var mock: ShoppingList {
        let list = ShoppingList(name: "Продукты на неделю")
        list.items = [
            GroceryItem(name: "Хлеб", isPurchased: true, quantity: 1),
            GroceryItem(name: "Молоко", isPurchased: false, quantity: 2),
            GroceryItem(name: "Яйца", isPurchased: false, quantity: 10),
            GroceryItem(name: "Сыр", isPurchased: true, quantity: 1)
        ]
        return list
    }

    // Моковый массив для превью
    static var mockArray: [ShoppingList] {
        let list1 = ShoppingList(name: "Продукты")
        list1.items = [
            GroceryItem(name: "Яблоки", isPurchased: true, quantity: 5),
            GroceryItem(name: "Бананы", isPurchased: false, quantity: 3),
            GroceryItem(name: "Молоко", isPurchased: false, quantity: 2)
        ]

        let list2 = ShoppingList(name: "Техника")
        list2.items = [
            GroceryItem(name: "Наушники", isPurchased: false, quantity: 1),
            GroceryItem(name: "Зарядка", isPurchased: true, quantity: 2)
        ]

        return [list1, list2]
    }
}
