import SwiftData

@Model
final class GroceryItem {
  var name: String
  var isPurchased: Bool
  var quantity: Int
  var unit: String

  var list: ShoppingList?

  init(
    name: String,
    isPurchased: Bool,
    quantity: Int,
    unit: String = "шт",
    list: ShoppingList? = nil
  ) {
    self.name = name
    self.isPurchased = isPurchased
    self.quantity = quantity
    self.unit = unit
    self.list = list
  }

  func copy(attachedTo list: ShoppingList? = nil) -> GroceryItem {
    GroceryItem(
      name: self.name,
      isPurchased: self.isPurchased,
      quantity: self.quantity,
      unit: self.unit,
      list: list
    )
  }
}
