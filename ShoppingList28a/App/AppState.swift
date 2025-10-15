import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var hasSeenOnboarding: Bool

    private let onboardingKey = "hasSeenOnboarding"

    init() {
        self.hasSeenOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
    }

    func markOnboardingAsSeen() {
        UserDefaults.standard.set(true, forKey: onboardingKey)
        hasSeenOnboarding = true
    }
}
