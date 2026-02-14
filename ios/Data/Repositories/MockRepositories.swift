import Foundation
import Combine

class MockActivityRepository: ActivityRepository {
    private var activities: [RunningActivity] = []
    
    func fetchActivities() -> AnyPublisher<[any Activity], Error> {
        Just(activities).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func fetchActivity(id: String) -> AnyPublisher<any Activity, Error> {
        guard let activity = activities.first(where: { $0.id == id }) else {
            return Fail(error: NSError(domain: "NotFound", code: 404, userInfo: nil)).eraseToAnyPublisher()
        }
        return Just(activity).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func saveActivity(_ activity: any Activity) -> AnyPublisher<Void, Error> {
        if let runningActivity = activity as? RunningActivity {
            activities.append(runningActivity)
        }
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func deleteActivity(id: String) -> AnyPublisher<Void, Error> {
        activities.removeAll { $0.id == id }
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func fetchActivities(for dateRange: ClosedRange<Date>) -> AnyPublisher<[any Activity], Error> {
        let filtered = activities.filter { dateRange.contains($0.startDate) }
        return Just(filtered).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

class MockUserRepository: UserRepository {
    private var user: User = User.current
    private var stats: UserStats = UserStats.empty
    
    func fetchCurrentUser() -> AnyPublisher<User, Error> {
        Just(user).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func updateUser(_ user: User) -> AnyPublisher<Void, Error> {
        self.user = user
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func fetchUserStats() -> AnyPublisher<UserStats, Error> {
        Just(stats).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

class MockGoalRepository: GoalRepository {
    private var goals: [Goal] = []
    
    func fetchGoals() -> AnyPublisher<[Goal], Error> {
        Just(goals).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func saveGoal(_ goal: Goal) -> AnyPublisher<Void, Error> {
        goals.append(goal)
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func deleteGoal(id: String) -> AnyPublisher<Void, Error> {
        goals.removeAll { $0.id == id }
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func updateGoalProgress(id: String, distance: Double) -> AnyPublisher<Void, Error> {
        if let index = goals.firstIndex(where: { $0.id == id }) {
            goals[index].currentDistance += distance
        }
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

class MockCollectibleRepository: CollectibleRepository {
    private var collectibles: [Collectible] = []
    
    func fetchCollectibles() -> AnyPublisher<[Collectible], Error> {
        Just(collectibles).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func unlockCollectible(id: String) -> AnyPublisher<Void, Error> {
        if let index = collectibles.firstIndex(where: { $0.id == id }) {
            collectibles[index].isUnlocked = true
            collectibles[index].unlockDate = Date()
        }
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func checkCollectibleRequirements(for activity: any Activity) -> AnyPublisher<[Collectible], Error> {
        // Simplified logic - would check requirements in real implementation
        return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
