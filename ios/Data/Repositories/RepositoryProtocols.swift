import Foundation
import Combine

protocol ActivityRepository {
    func fetchActivities() -> AnyPublisher<[any Activity], Error>
    func fetchActivity(id: String) -> AnyPublisher<any Activity, Error>
    func saveActivity(_ activity: any Activity) -> AnyPublisher<Void, Error>
    func deleteActivity(id: String) -> AnyPublisher<Void, Error>
    func fetchActivities(for dateRange: ClosedRange<Date>) -> AnyPublisher<[any Activity], Error>
}

protocol UserRepository {
    func fetchCurrentUser() -> AnyPublisher<User, Error>
    func updateUser(_ user: User) -> AnyPublisher<Void, Error>
    func fetchUserStats() -> AnyPublisher<UserStats, Error>
}

protocol GoalRepository {
    func fetchGoals() -> AnyPublisher<[Goal], Error>
    func saveGoal(_ goal: Goal) -> AnyPublisher<Void, Error>
    func deleteGoal(id: String) -> AnyPublisher<Void, Error>
    func updateGoalProgress(id: String, distance: Double) -> AnyPublisher<Void, Error>
}

protocol CollectibleRepository {
    func fetchCollectibles() -> AnyPublisher<[Collectible], Error>
    func unlockCollectible(id: String) -> AnyPublisher<Void, Error>
    func checkCollectibleRequirements(for activity: any Activity) -> AnyPublisher<[Collectible], Error>
}
