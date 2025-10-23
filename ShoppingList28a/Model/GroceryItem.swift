import Foundation
import SwiftData

@Model
final class GroceryItem {
    var name: String
    var isPurchased: Bool
    var quantity: Int
    var unit: String

    @Relationship(inverse: \ShoppingList.items)
    var list: ShoppingList?

    init(
        name: String,
        isPurchased: Bool,
        quantity: Int,
        unit: String,
        list: ShoppingList
    ) {
        self.name = name
        self.isPurchased = isPurchased
        self.quantity = quantity
        self.unit = unit
        self.list = list
    }

    func copy(attachedTo list: ShoppingList) -> GroceryItem {
        GroceryItem(
            name: name,
            isPurchased: isPurchased,
            quantity: quantity,
            unit: unit,
            list: list
        )
    }
}
