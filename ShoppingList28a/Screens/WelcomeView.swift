import SwiftUI

struct WelcomeView: View {
  @EnvironmentObject var appState: AppState
  var onStart: (() -> Void)?

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
        appState.markOnboardingAsSeen()
      }
      .padding(20)
    }
    .multilineTextAlignment(.center)
  }
}

#Preview {
  WelcomeView()
    .environmentObject(AppState())
}
