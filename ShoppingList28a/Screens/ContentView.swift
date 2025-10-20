import SwiftUI

struct ContentView: View {
  @State private var hasOnboarded: Bool = false

  var body: some View {
    NavigationStack {
      if hasOnboarded {
        MainView()
      } else {
        WelcomeView {
          hasOnboarded = true
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
