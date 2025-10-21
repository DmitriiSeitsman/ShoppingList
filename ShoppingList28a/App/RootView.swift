import SwiftUI

struct RootView: View {
  @EnvironmentObject var appState: AppState

  var body: some View {
    NavigationStack {
      if appState.hasSeenOnboarding {
        MainView()
      } else {
        WelcomeView()
      }
    }
  }
}

#Preview {
  RootView()
    .environmentObject(AppState())
}
