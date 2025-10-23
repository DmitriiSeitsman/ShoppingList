import Foundation
import SwiftData

@Model
final class ShoppingList {
  var name: String
  var createdAt: Date

  var iconName: String
  var iconColor: String

  @Relationship(deleteRule: .cascade, inverse: \GroceryItem.list)
  var items: [GroceryItem] = []

  init(
    name: String,
    createdAt: Date = .now,
    iconName: String = "iconCart",
    iconColor: String = "slYellowAdditional",
    items: [GroceryItem] = []
  ) {
    self.name = name
    self.createdAt = createdAt
    self.iconName = iconName
    self.iconColor = iconColor
    self.items = items
  }

  var purchasedCount: Int {
    items.filter { $0.isPurchased }.count
  }

  func copy(name: String? = nil, createdAt: Date = .now) -> ShoppingList {
    let copy = ShoppingList(
      name: name ?? self.name,
      createdAt: createdAt,
      iconName: self.iconName,
      iconColor: self.iconColor
    )
    copy.items = self.items.map { $0.copy(attachedTo: copy) }
    return copy
  }

}
