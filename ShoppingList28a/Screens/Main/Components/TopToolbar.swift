import SwiftUI

struct TopToolbar: ToolbarContent {
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    @Binding var sortBy: MainView.SortOption
    
    var body: some ToolbarContent {
        if #available(iOS 26, *) {
            ToolbarItem(placement: .principal) {
                Text("Мои списки")
                    .font(.title1)
                    .foregroundColor(.slBlackFontsTitle)
                    .frame(height: 52)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                menuButton
            }
        } else {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("Мои списки")
                    .font(.title1)
                    .foregroundColor(.slBlackFontsTitle)
                    .frame(height: 52)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                menuButton
            }
        }
    }
    
    private var menuButton: some View {
        Menu {
            Picker("Тема", selection: $appTheme) {
                ForEach(AppTheme.allCases) { theme in
                    Text(theme.title).tag(theme)
                }
            }
            .onChange(of: appTheme) { _, newTheme in
                ThemeManager.apply(newTheme)
            }
            
            Divider()
            
            Button {
                sortBy = (sortBy == .name) ? .date : .name
            } label: {
                HStack {
                    Label("Сортировать по алфавиту", systemImage: "arrow.up.arrow.down")
                    Spacer()
                    if sortBy == .name {
                        Image(systemName: "checkmark")
                            .foregroundColor(.red)
                    }
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .imageScale(.large)
                .foregroundColor(.slBlackFontsTitle)
        }
    }
}
