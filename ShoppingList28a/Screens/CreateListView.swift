import SwiftUI

struct CreateListView: View {
    // MARK: - Environment
    @EnvironmentObject private var router: Router
    
    // MARK: - State
    @State private var listTitle: String = ""
    @State private var selectedColor: Color?
    @State private var selectedIcon: String?
    
    // MARK: - Computed
    private var isButtonActive: Bool {
        !listTitle.isEmpty && selectedColor != nil && selectedIcon != nil
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            headerView
            contentView
            PrimaryButton(title: "Создать", isActive: isButtonActive) {
                guard let selectedColor else { return }
                guard let selectedIcon else { return }
                
                let newList = ShoppingList(
                    name: listTitle,
                    iconName: selectedIcon,
                    iconColor: selectedColor.assetName ?? "slYellowAdditional"
                )
                
                // Здесь далее вставить сохранение в SwiftData
                // context.insert(newList)
                // try? context.save()
                
                router.push(.storySet(newList))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .background(Color.slBackground.ignoresSafeArea())
    }
    
    // MARK: - Subviews
    private var headerView: some View {
        HStack(spacing: 8) {
            Button {
                router.pop()
            } label: {
                Image("IconChevronLeft")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.slBlackFontsTitle)
                    .frame(width: 8, height: 16)
                    .padding(6)
                    .contentShape(Rectangle())
            }
            .frame(width: 28, height: 44)
            .buttonStyle(.plain)
            
            Text("Создать список")
                .font(.appHeadline)
                .foregroundColor(.slBlackFontsTitle)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }
    
    private var contentView: some View {
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
    }
}

#Preview {
    CreateListView()
        .environmentObject(Router())
}
