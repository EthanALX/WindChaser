import Foundation

struct Goal: Identifiable, Codable {
    let id: String
    var title: String
    var targetDistance: Double
    var currentDistance: Double
    var startDate: Date
    var endDate: Date
    var isCompleted: Bool
    var activityTypes: [ActivityType]
    
    var progress: Double {
        guard targetDistance > 0 else { return 0 }
        return min(currentDistance / targetDistance, 1.0)
    }
    
    var remainingDistance: Double {
        return max(targetDistance - currentDistance, 0)
    }
    
    var formattedProgress: String {
        return String(format: "%.0f%%", progress * 100)
    }
}

enum GoalType: String, Codable {
    case distance = "Distance"
    case duration = "Duration"
    case activities = "Activities"
    case streak = "Streak"
}
