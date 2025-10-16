import SwiftUI

struct BaseTextField: View {
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .trailing) {
                TextField(placeholder, text: $text)
                    .padding(.horizontal, 16)
                    .frame(height: 54)
                    .background(Color.slFramesBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isError ? Color.slRedSystem : Color.slFramesBackground, lineWidth: 0.5)
                    )
                    .cornerRadius(12)
                    .font(.appBody)
                    .foregroundColor(.slBlackFontsTitle)
                    .disableAutocorrection(true)
                
                if !text.isEmpty {
                    Button(action: {
                        withAnimation {
                            text = ""
                        }
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.slGreySystem)
                            .padding(.trailing, 16)
                    })
                    .transition(.opacity.combined(with: .scale))
                }
            }
            
            if isError, let errorText {
                Text(errorText)
                    .font(.appFootnote)
                    .foregroundColor(.slRedSystem)
                    .padding(.horizontal, 8)
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity)
            }
        }
        .padding(.horizontal, 16)
        .animation(.easeInOut(duration: 0.2), value: text)
    }
    
    // MARK: - Properties
    let placeholder: String
    @Binding var text: String
    let isError: Bool
    let errorText: String?
}

#Preview("Interactive • Fullscreen") {
    ZStack {
        Color.slBackground
            .ignoresSafeArea()
        
        InteractivePreview()
    }
}

// MARK: - Interactive Preview (без лишних кнопок)
private struct InteractivePreview: View {
    var body: some View {
        VStack {
            Spacer()
            
            BaseTextField(
                placeholder: "Название списка",
                text: $text,
                isError: isError,
                errorText: errorText
            )
            
            Spacer()
        }
        .onChange(of: text) { _, newValue in
            // «демо-валидация» для превью:
            // "111" — покажет ошибку №1
            // "222" — покажет ошибку №2
            // иначе — без ошибки
            switch newValue.lowercased() {
            case let input where input.contains("111"):
                isError = true
                errorText = "Это название уже используется, пожалуйста, измените его."
            case let input where input.contains("222"):
                isError = true
                errorText = "Этот товар уже есть в списке, добавьте другой."
            default:
                isError = false
                errorText = nil
            }
        }
    }
    
    @State private var text: String = ""
    @State private var isError: Bool = false
    @State private var errorText: String?
}
