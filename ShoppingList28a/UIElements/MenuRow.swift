import SwiftUI

struct MenuRow: View {
    let title: String
    let icon: String
    var isDestructive: Bool = false
    var iconColor: Color = .primary
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.body)
                    .foregroundColor(isDestructive ? .red : .primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(maxWidth: 200, alignment: .leading)

                Spacer()

                Image(systemName: icon)
                    .foregroundColor(isDestructive ? .red : iconColor)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
        }
    }
}
