import Foundation
import Combine

/// 跑步数据 Repository 实现
final class RunningRepositoryImpl: RunningRepository {

    // MARK: - Properties

    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    // MARK: - Init

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()

        // 设置日期格式
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            if let date = dateFormatter.date(from: dateString) {
                return date
            }

            return Date()
        }
    }

    // MARK: - Public Methods

    func getUserStats() -> AnyPublisher<UserStats, Never> {
        // TODO: 从本地存储或网络获取真实数据
        // 这里返回模拟数据
        let stats = UserStats(
            totalDistance: 2450.0,
            totalRuns: 156,
            totalMarathons: 42,
            avgPace: 5.5,
            activeDays: 142,
            personalBests: PersonalBests(
                fiveK: "19:42",
                tenK: "41:15",
                halfMarathon: "1:32:04",
                marathon: "3:15:30"
            )
        )

        return Just(stats)
            .eraseToAnyPublisher()
    }

    func getAllActivities() -> AnyPublisher<[RunningActivity], Never> {
        // TODO: 从数据库获取真实数据
        return Just([])
            .eraseToAnyPublisher()
    }

    func getLatestActivity() -> AnyPublisher<RunningActivity?, Never> {
        // TODO: 从数据库获取最新活动
        return Just(nil)
            .eraseToAnyPublisher()
    }

    func getAllRoutes() -> AnyPublisher<[Route], Never> {
        // 返回东京环线示例数据
        let tokyoLoop = Route(
            id: "tokyo_loop",
            name: "Tokyo Loop",
            coordinates: [
                Coordinate(latitude: 35.6930, longitude: 139.7020),
                Coordinate(latitude: 35.7010, longitude: 139.7130),
                Coordinate(latitude: 35.7070, longitude: 139.7280),
                Coordinate(latitude: 35.6980, longitude: 139.7420),
                Coordinate(latitude: 35.6860, longitude: 139.7440),
                Coordinate(latitude: 35.6740, longitude: 139.7340),
                Coordinate(latitude: 35.6670, longitude: 139.7180),
                Coordinate(latitude: 35.6650, longitude: 139.7010),
                Coordinate(latitude: 35.6710, longitude: 139.6860),
                Coordinate(latitude: 35.6830, longitude: 139.6760),
                Coordinate(latitude: 35.6960, longitude: 139.6810),
                Coordinate(latitude: 35.7050, longitude: 139.6920),
                Coordinate(latitude: 35.7060, longitude: 139.7030),
                Coordinate(latitude: 35.7010, longitude: 139.7120),
                Coordinate(latitude: 35.6930, longitude: 139.7020)
            ],
            distance: 15.2,
            type: .loop
        )

        return Just([tokyoLoop])
            .eraseToAnyPublisher()
    }

    func getRouteById(_ routeId: String) -> Route? {
        // TODO: 实现从存储中查询
        return nil
    }

    func saveActivity(_ activity: RunningActivity) {
        // TODO: 保存到本地数据库
    }

    func syncData() -> AnyPublisher<Void, Error> {
        // TODO: 实现网络同步
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
