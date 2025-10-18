import Foundation
import SwiftData

@Model
final class ListItem {
    var name: String
    var isPurchased: Bool
    var quantity: Int
    var createdAt: Date
    
    init(name: String, isPurchased: Bool = false, quantity: Int = 1, createdAt: Date = .now) {
        self.name = name
        self.isPurchased = isPurchased
        self.quantity = quantity
        self.createdAt = createdAt
    }
    
    // Моковый элемент для превью
    static var mock: ListItem {
        ListItem(name: "Mackbook Pro", isPurchased: false, quantity: 2)
    }
    
    static var mockArray: [ListItem] {
        [
            ListItem(name: "Notebook MSI", isPurchased: true, quantity: 3),
            ListItem(name: "Monitor Asus", isPurchased: false, quantity: 3),
            ListItem(name: "Mouse Razer", isPurchased: false, quantity: 5)
        ]
    }
}
