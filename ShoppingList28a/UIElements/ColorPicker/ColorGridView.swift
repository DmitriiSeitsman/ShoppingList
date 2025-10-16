import SwiftUI

struct ColorGridView: View {
    
    @Binding var selectedColor: Color?
    let colors: [Color]
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Выберите цвет")
                .font(.appCallout)
                .foregroundColor(.slBlackFontsTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
            
            HStack(spacing: 20) {
                ForEach(colors, id: \.self) { color in
                    ColorTileView(
                        color: color,
                        isSelected: selectedColor == color,
                        size: 40,
                        onTap: {
                            if selectedColor == color {
                                selectedColor = nil
                            } else {
                                selectedColor = color
                            }
                        }
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 105)
        .background(Color.slFramesBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 16)
        .animation(.easeInOut(duration: 0.2), value: selectedColor)
    }
}

#Preview("Interactive Grid") {
    PreviewContainer()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.slBackground)
        .ignoresSafeArea()
}

// MARK: - Interactive Preview Container
private struct PreviewContainer: View {
    @State private var selectedColor: Color?
    
    private let colors = [
        Color.slBlueAdditional,
        Color.slGreenAdditional,
        Color.slPurpleAdditional,
        Color.slRedAdditional,
        Color.slYellowAdditional
    ]
    
    var body: some View {
        ColorGridView(
            selectedColor: $selectedColor,
            colors: colors
        )
    }
}
