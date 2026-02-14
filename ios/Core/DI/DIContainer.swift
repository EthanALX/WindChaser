import Foundation
import SwiftUI
import Combine

/// Dependency Injection Container
/// 简单的依赖注入容器，管理应用中的所有依赖
@propertyWrapper
struct Inject<T> {
    let wrappedValue: T

    init(_ type: T.Type) {
        self.wrappedValue = DIContainer.shared.resolve(type)
    }
}

/// DI Container 单例
final class DIContainer {
    static let shared = DIContainer()

    private var dependencies: [String: Any] = [:]

    private init() {
        registerDependencies()
    }

    /// 注册所有依赖
    private func registerDependencies() {
        // Repository registration placeholder
        // Implementation pending project structure integration
    }

    /// 注册依赖
    func register<T>(_ type: T.Type, instance: Any) {
        let key = String(describing: type)
        dependencies[key] = instance
    }

    /// 解析依赖
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let instance = dependencies[key] as? T else {
            fatalError("Dependency \(type) not registered")
        }
        return instance
    }

    /// 无参数解析依赖（推断类型）
    func resolve<T>() -> T {
        let key = String(describing: T.self)
        guard let instance = dependencies[key] as? T else {
            fatalError("Dependency \(T.self) not registered")
        }
        return instance
    }
}

/// App Environment ObservableObject
class AppEnvironment: ObservableObject {
    @Published var isLoading = false
    @Published var error: AppError?

    static let shared = AppEnvironment()

    private init() {}
}

/// App Error 类型
enum AppError: Error, LocalizedError {
    case networkError(String)
    case locationError(String)
    case mapError(String)
    case dataError(String)

    var errorDescription: String? {
        switch self {
        case .networkError(let message),
             .locationError(let message),
             .mapError(let message),
             .dataError(let message):
            return message
        }
    }
}
