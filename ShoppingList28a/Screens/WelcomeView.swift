import SwiftUI

struct WelcomeView: View {
  var onStart: (() -> Void)? = nil

  var body: some View {
    VStack(spacing: 0) {
      Text("Добро пожаловать!")
        .font(.largeTitle)
        .padding(.top, 32)

      Image("ImageEnterScreen")
        .resizable()
        .scaledToFit()
        .padding(50)

      Spacer()

      VStack(spacing: 16) {
        Text("Никогда не забывайте, \nчто нужно купить")
          .font(.title2)

        Text("Создавайте списки \nи не переживайте о покупках")
          .font(.appBody)
      }

      Spacer()

      PrimaryButton(title: "Начать") {
        onStart?()
      }
      .padding(20)
    }
    .multilineTextAlignment(.center)
  }
}

#Preview {
  WelcomeView()
}
