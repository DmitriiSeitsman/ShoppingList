import SwiftUI

extension ShoppingList {
  static var preview: ShoppingList {
    let list = ShoppingList(
      name: "Продукты на неделю",
      iconName: "IconBriefcase",
      iconColor: "slYellowAdditional"
    )
    list.items = [
      GroceryItem(name: "Хлеб", isPurchased: true, quantity: 1, unit: "шт", list: list),
      GroceryItem(name: "Молоко", isPurchased: false, quantity: 2, unit: "шт", list: list),
    ]
    return list
  }

  static var previewArray: [ShoppingList] {
    let list1 = ShoppingList(
      name: "Очень длинное название списка покупок на всю неделю вперед",
      iconName: "IconBriefcase",
      iconColor: "slRedAdditional"
    )
    list1.items = [
      GroceryItem(name: "Хлеб", isPurchased: true, quantity: 1, unit: "шт", list: list1),
      GroceryItem(name: "Молоко", isPurchased: false, quantity: 2, unit: "шт", list: list1),
      GroceryItem(name: "Яйца", isPurchased: false, quantity: 10, unit: "шт", list: list1),
      GroceryItem(name: "Сыр", isPurchased: true, quantity: 1, unit: "шт", list: list1),
    ]

    let list2 = ShoppingList(
      name: "Техника",
      iconName: "IconCar",
      iconColor: "slPurpleAdditional"
    )
    list2.items = [
      GroceryItem(name: "Наушники", isPurchased: false, quantity: 1, unit: "шт", list: list2),
      GroceryItem(name: "Зарядка", isPurchased: true, quantity: 2, unit: "шт", list: list2),
    ]
    return [list1, list2]
  }
}
