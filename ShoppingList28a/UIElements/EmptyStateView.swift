import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image("ImagemainScreen")
            
            VStack(spacing: 8) {
                Text("Давайте спланируем покупки!")
                    .font(.title3)
                Text("Создайте свой первый список")
                    .font(.appBody)
            }
            .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    EmptyStateView()
}
