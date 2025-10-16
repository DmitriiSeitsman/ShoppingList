import SwiftUI

struct CreateListView: View {
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            
            HStack(spacing: 8) {
                Button {
                    print("возврат к экрану мои списки")
                } label: {
                    Image("IconChevronLeft")
                        .resizable()
                        .frame(width: 8, height: 16)
                        .frame(width: 28, height: 28)
                        .contentShape(Rectangle())
                        .frame(width: 28, height: 44)
                }
                .buttonStyle(.plain)
                
                Text("Создать список")
                    .font(.appHeadline)
                    .foregroundColor(.slBlackFontsTitle)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    BaseTextField(
                        placeholder: "Введите название списка",
                        text: $listTitle,
                        isError: false,
                        errorText: nil
                    )
                    .padding(.top, 12)
                    
                    ColorGridView(
                        selectedColor: $selectedColor,
                        colors: ListUIConstants.availableColors
                    )
                    
                    IconGridView(
                        selectedIcon: $selectedIcon,
                        icons: ListUIConstants.availableIcons,
                        selectionColor: selectedColor ?? .slGreyButton
                    )
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 20)
            }
            
            PrimaryButton(title: "Создать", isActive: isButtonActive) {
                print("Создать список с названием: \(listTitle)")
                print("Цвет: \(String(describing: selectedColor))")
                print("Иконка: \(String(describing: selectedIcon))")
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(Color.slBackground.ignoresSafeArea())
    }
    // MARK: - State
    @State private var listTitle: String = ""
    @State private var selectedColor: Color?
    @State private var selectedIcon: String?
    
    // MARK: - Computed
    private var isButtonActive: Bool {
        !listTitle.isEmpty && selectedColor != nil && selectedIcon != nil
    }
}

// MARK: - Preview
#Preview {
    CreateListView()
}
