import SwiftUI

struct TopToolbar: ToolbarContent {
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    @Binding var sortBy: MainView.SortOption

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Text("Мои списки")
                .font(.title1)
                .foregroundColor(.slBlackFontsTitle)
        }

        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                // MARK: - Выбор темы
                Picker("Тема", selection: $appTheme) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(theme.title).tag(theme)
                    }
                }
                .onChange(of: appTheme) { _, newTheme in
                    ThemeManager.apply(newTheme)
                }

                Divider()

                // MARK: - Сортировка
                Button {
                    sortBy = (sortBy == .none) ? .name : .none
                } label: {
                    HStack {
                        Label("Сортировать по алфавиту", systemImage: "arrow.up.arrow.down")
                        Spacer()
                        if sortBy == .name {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .tint(.slBlackFontsTitle)
        }
    }
}
