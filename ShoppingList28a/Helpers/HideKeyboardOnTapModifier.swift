import SwiftUI

// MARK: - Расширение для скрытия клавиатуры по тапу
extension View {
    
    func hideKeyboardOnTap() -> some View {
        modifier(HideKeyboardOnTapModifier())
    }

    func hideKeyboard() {
#if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
#endif
    }
}

// MARK: - ViewModifier
private struct HideKeyboardOnTapModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .gesture(
                TapGesture().onEnded {
#if canImport(UIKit)
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil, from: nil, for: nil)
#endif
                }
            )
    }
}
