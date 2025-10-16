import SwiftUI

struct ColorTileView: View {
    let color: Color
    let isSelected: Bool
    let size: CGFloat
    let onTap: () -> Void
    
    var body: some View {
            Button(action: onTap) {
                Circle()
                    .fill(color)
                    .frame(width: size, height: size)
                    .overlay {
                        if isSelected {
                            Circle()
                                .stroke(Color.slTurquoise, lineWidth: 2)
                                .frame(width: size + 8, height: size + 8)
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
            .buttonStyle(.plain)
        }
    }

#Preview("Color Tile Examples") {
    HStack(spacing: 12) {
        ColorTileView(
            color: .slBlueAdditional,
            isSelected: true,
            size: 40,
            onTap: {}
        )
        ColorTileView(
            color: .slGreenAdditional,
            isSelected: false,
            size: 40,
            onTap: {}
        )
    }
    .padding()
}
