import SwiftUI

struct EmptyGroceryStateView: View {
    @Binding var showingAddItem: Bool

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Image("ImageStorysetScreen")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 200)

            VStack(spacing: 8) {
                Text("Давайте спланируем покупки!")
                    .font(.title3)
                    .foregroundColor(.slBlackFontsMain)
                Text("Начните добавлять товары")
                    .font(.appBody)
                    .foregroundColor(.slBlackFontsMain)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)

            Spacer()

            PrimaryButton(title: "Добавить товар", isActive: true) {
                showingAddItem = true
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(Color.slFramesBackground.ignoresSafeArea())
    }
}

#Preview {
    EmptyGroceryStateView(showingAddItem: .constant(false))
}
