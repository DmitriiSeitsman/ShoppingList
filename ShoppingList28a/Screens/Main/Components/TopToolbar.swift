import SwiftUI

struct TopToolbar: ToolbarContent {
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    @Binding var sortBy: MainView.SortOption

    var body: some ToolbarContent {
        if #available(iOS 26.0, *) {
            ToolbarItem(placement: .title) {
                Text("Мои списки")
                    .font(.title1)
                    .foregroundColor(.slBlackFontsTitle)
            }
            ToolbarItem(placement: .secondaryAction) {
                Picker(selection: $appTheme) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(theme.title).tag(theme)
                    }
                } label: {
                    Label("Установить тему", systemImage: "circle.righthalf.filled")
                }
                .pickerStyle(.menu)
                .onChange(of: appTheme) { _, newTheme in
                    ThemeManager.apply(newTheme)
                }
            }
            ToolbarItem(placement: .secondaryAction) {
                Button {
                    sortBy = (sortBy == .none) ? .name : .none
                } label: {
                    HStack {
                        Label("Сортировать по Алфавиту", systemImage: "arrow.up.arrow.down")
                        Spacer()
                        if sortBy == .name {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } else {
            ToolbarItem(placement: .topBarLeading) {
                Text("Мои списки")
                    .font(.title1)
                    .foregroundColor(.slBlackFontsTitle)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker(selection: $appTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.title).tag(theme)
                        }
                    } label: {
                        Label("Установить тему", systemImage: "circle.righthalf.filled")
                    }
                    .pickerStyle(.menu)
                    .onChange(of: appTheme) { _, newTheme in
                        ThemeManager.apply(newTheme)
                    }

                    Button {
                        sortBy = (sortBy == .none) ? .name : .none
                    } label: {
                        HStack {
                            Label("Сортировать по Алфавиту", systemImage: "arrow.up.arrow.down")
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
}
