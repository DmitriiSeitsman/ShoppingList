import SwiftUI

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
            .animation(.easeInOut(duration: 0.15), value: isActive)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
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

struct PrimaryButton: View {
    
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(PrimaryButtonStyle(isActive: isActive))
        .foregroundColor(isActive ? .slWhite : .slGrey)
        .disabled(!isActive)
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
