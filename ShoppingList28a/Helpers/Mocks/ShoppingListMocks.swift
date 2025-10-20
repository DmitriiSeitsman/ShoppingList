import SwiftUI

extension ShoppingList {
    static var preview: ShoppingList {
        let list = ShoppingList(
            name: "Продукты на неделю",
            iconName: "IconBriefcase",
            iconColor: "slYellowAdditional"
        )
        list.items = [
            GroceryItem(name: "Хлеб", isPurchased: true, quantity: 1),
            GroceryItem(name: "Молоко", isPurchased: false, quantity: 2)
        ]
        return list
    }
    
    static var previewArray: [ShoppingList] {
        [
            ShoppingList(
                name: "Очень длинное название списка покупок на всю неделю вперед",
                iconName: "IconBriefcase",
                iconColor: "slRedAdditional",
                items: [
                    GroceryItem(name: "Хлеб", isPurchased: true, quantity: 1),
                    GroceryItem(name: "Молоко", isPurchased: false, quantity: 2),
                    GroceryItem(name: "Яйца", isPurchased: false, quantity: 10),
                    GroceryItem(name: "Сыр", isPurchased: true, quantity: 1)
                ]
            ),
            ShoppingList(
                name: "Техника",
                iconName: "IconCar",
                iconColor: "slPurpleAdditional",
                items: [
                    GroceryItem(name: "Наушники", isPurchased: false, quantity: 1),
                    GroceryItem(name: "Зарядка", isPurchased: true, quantity: 2)
                ]
            )
        ]
    }
}
