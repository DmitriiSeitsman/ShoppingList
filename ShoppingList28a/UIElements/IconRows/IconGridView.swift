import SwiftUI

struct IconGridView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Выберите дизайн")
                .font(.appCallout)
                .foregroundColor(.slBlackFontsTitle)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(icons, id: \.self) { iconName in
                    IconTileView(
                        iconName: iconName,
                        isSelected: selectedIcon == iconName,
                        size: 48,
                        selectionColor: selectionColor
                    ) {
                        if selectedIcon == iconName {
                            selectedIcon = nil
                        } else {
                            selectedIcon = iconName
                        }
                    }
                }
            }
        }
        .frame(height: 225)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.slFramesBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .animation(.easeInOut(duration: 0.2), value: selectedIcon)
    }
    
    @Binding var selectedIcon: String?
    let icons: [String]
    let selectionColor: Color
    
    private let columns = Array(repeating: GridItem(.fixed(48), spacing: 8), count: 6)
}

#Preview("Interactive Grid") {
    VStack {
        Spacer()
        PreviewContainer()
            .padding(16)
        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.slBackground)
    .ignoresSafeArea()
}

// MARK: - Interactive Preview Container
private struct PreviewContainer: View {
    @State private var selectedIcon: String?
    
    private let icons = [
        "IconSnow", "IconPlane", "IconAlert", "IconBalloon", "IconBandage", "IconBarbell",
        "IconBed", "IconBriefcase", "IconBuild", "IconBusiness", "IconCalendar", "IconCar",
        "IconCart", "IconFastFood", "IconGift", "IconPalette", "IconPaw", "IconGameController"
    ]
    
    var body: some View {
        IconGridView(
            selectedIcon: $selectedIcon,
            icons: icons,
            selectionColor: .slBlueAdditional
        )
    }
}
