import Foundation
import Combine

/// 获取用户统计数据用例
final class GetUserStatsUseCase {
    private let repository: RunningRepository

    init(repository: RunningRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<UserStats, Never> {
        return repository.getUserStats()
    }
}

/// 获取最新活动用例
final class GetLatestActivityUseCase {
    private let repository: RunningRepository

    init(repository: RunningRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<RunningActivity?, Never> {
        return repository.getLatestActivity()
    }
}

/// 获取所有路线用例
final class GetAllRoutesUseCase {
    private let repository: RunningRepository

    init(repository: RunningRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[Route], Never> {
        return repository.getAllRoutes()
    }
}

/// 同步数据用例
final class SyncDataUseCase {
    private let repository: RunningRepository

    init(repository: RunningRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<Void, Error> {
        return repository.syncData()
    }
}
