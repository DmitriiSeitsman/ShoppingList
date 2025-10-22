import SwiftUI
import Combine

/// Глобальный роутер приложения, управляющий стеком экранов.
///
/// Работает совместно с `NavigationStack(path:)` в `RootView`.
/// Позволяет переходить между экранами без прямых `NavigationLink` —
/// всё управление навигацией централизовано.
///
/// Пример использования:
/// ```swift
/// router.push(.createList)
/// router.pop()
/// router.reset()
/// router.replaceTop(with: .storySet(list))
/// ```
@MainActor
final class Router: ObservableObject {
    // MARK: - Published properties
    
    /// Текущий стек маршрутов.
    /// Используется `NavigationStack(path:)` в `RootView`.
    @Published var path: [AppRoute] = []
    
    // MARK: - Basic navigation actions
    
    /// Открывает новый экран и добавляет его в стек.
    /// - Parameter route: маршрут для перехода.
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    /// Открывает сразу несколько экранов последовательно.
    /// Полезно, если нужно проложить цепочку переходов.
    /// - Parameter routes: список маршрутов.
    func push(_ routes: [AppRoute]) {
        path.append(contentsOf: routes)
    }
    
    /// Закрывает верхний экран и возвращается на предыдущий.
    /// - Returns: удалённый маршрут (если был).
    @discardableResult
    func pop() -> AppRoute? {
        path.popLast()
    }
    
    /// Полностью очищает стек маршрутов.
    /// Используется, например, при выходе из онбординга
    /// или при логауте пользователя.
    func reset() {
        path.removeAll()
    }
    
    /// Заменяет текущий верхний экран новым.
    /// Полезно, когда нужно перезаписать состояние текущего маршрута,
    /// не возвращаясь назад и не добавляя дубликаты.
    /// - Parameter route: новый маршрут для верхнего уровня стека.
    func replaceTop(with route: AppRoute) {
        if !path.isEmpty {
            path.removeLast()
        }
        path.append(route)
    }
}
