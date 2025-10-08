import SwiftUI

struct PrimaryButton: View {
    
    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(PrimaryButtonStyle(isActive: isActive))
        .foregroundColor(isActive ? .slWhite : .slGrey)
        .disabled(!isActive)
    }
    
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    init(title: String, isActive: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isActive = isActive
        self.action = action
    }
}

private struct PrimaryButtonStyle: ButtonStyle {
    
    let isActive: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(backgroundColor(isPressed: configuration.isPressed))
            .clipShape(Capsule())
    }
    
    private func backgroundColor(isPressed: Bool) -> Color {
        if !isActive {
            return Color(.slGreyButton)
        }
        if isPressed {
            return Color(.slPressed)
        } else {
            return Color(.slTurquoise)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(title: "Активная кнопка", isActive: true) {
            print("Активная кнопка нажата!")
        }
        
        PrimaryButton(title: "Неактивная кнопка", isActive: false) {
            print("Неактивная кнопка нажата!")
        }
    }
    .padding()
}
