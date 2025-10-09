import SwiftUI

struct IconTileView: View {

    var body: some View {
        Button(action: onTap) {
            ZStack {
                Circle()
                    .fill(isSelected ? selectionColor : Color.slIconBackgroun)
                    .frame(width: size, height: size)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)

                Image(iconName)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(isSelected ? .slActiveIcon : .slFramesBackground)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
        }
        .buttonStyle(.plain)
    }
    
    let iconName: String
    let isSelected: Bool
    let size: CGFloat
    let selectionColor: Color
    let onTap: () -> Void
}

#Preview {
    VStack(spacing: 16) {
        IconTileView(
            iconName: "IconSnow",
            isSelected: true,
            size: 48,
            selectionColor: .slBlueAdditional,
            onTap: {}
        )
        IconTileView(
            iconName: "IconPlane",
            isSelected: false,
            size: 48,
            selectionColor: .slBlueAdditional,
            onTap: {}
        )
    }
    .padding()
    .background(Color.slFramesBackground)
}
