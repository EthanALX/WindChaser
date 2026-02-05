import Foundation
import Combine

/// 跑步数据 Repository 协议
protocol RunningRepository {
    /// 获取用户统计数据
    func getUserStats() -> AnyPublisher<UserStats, Never>

    /// 获取所有跑步活动
    func getAllActivities() -> AnyPublisher<[RunningActivity], Never>

    /// 获取最新活动
    func getLatestActivity() -> AnyPublisher<RunningActivity?, Never>

    /// 获取所有路线
    func getAllRoutes() -> AnyPublisher<[Route], Never>

    /// 根据ID获取路线
    func getRouteById(_ routeId: String) -> Route?

    /// 保存跑步活动
    func saveActivity(_ activity: RunningActivity)

    /// 同步数据
    func syncData() -> AnyPublisher<Void, Error>
}
