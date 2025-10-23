import SwiftUI

extension Color {
    /// Возвращает имя цвета из ассетов (если есть), иначе nil.
    var assetName: String? {
        switch self {
        case .slBlueAdditional: return "slBlueAdditional"
        case .slGreenAdditional: return "slGreenAdditional"
        case .slPurpleAdditional: return "slPurpleAdditional"
        case .slRedAdditional: return "slRedAdditional"
        case .slYellowAdditional: return "slYellowAdditional"
        default: return nil
        }
    }
    
    /// Восстанавливает Color по имени ассета
    static func fromAsset(_ name: String) -> Color {
        Color(name)
    }
}
