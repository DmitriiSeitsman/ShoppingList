import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    HStack(spacing: 18) {
      ZStack {
        Image(systemName: "square.fill")
          .resizable()
          .frame(width: 22, height: 22)
          .foregroundColor(configuration.isOn ? .slTurquoise : .clear)
          .animation(.linear(duration: 0.15), value: configuration.isOn)
        Image(systemName: configuration.isOn ? "checkmark.square" : "square")
          .resizable()
          .frame(width: 22, height: 22)
          .symbolRenderingMode(.palette)
          .foregroundStyle(
            configuration.isOn ? .slWhite : .slGreyList, .clear
          )
          .contentTransition(.symbolEffect(.replace))
      }
      configuration.label
    }
    .frame(height: 44)
    .padding(.leading, 12)
    .onTapGesture { configuration.isOn.toggle() }
  }
}

extension ToggleStyle where Self == CheckboxToggleStyle {
  static var checkbox: CheckboxToggleStyle { CheckboxToggleStyle() }
}
