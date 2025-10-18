import Foundation

struct GroceryItem: Identifiable {
    let id = UUID()
    let name: String
    var isPurchased: Bool
    var quantity: Int
    var unit: String = "шт"
}
