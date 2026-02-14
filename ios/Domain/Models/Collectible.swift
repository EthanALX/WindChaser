import Foundation

struct Collectible: Identifiable, Codable {
    let id: String
    var name: String
    var description: String
    var imageName: String
    var isUnlocked: Bool
    var unlockDate: Date?
    var rarity: CollectibleRarity
    var category: CollectibleCategory
    var requirements: [CollectibleRequirement]
}

enum CollectibleRarity: String, Codable, CaseIterable {
    case common = "Common"
    case uncommon = "Uncommon"
    case rare = "Rare"
    case epic = "Epic"
    case legendary = "Legendary"
    
    var color: String {
        switch self {
        case .common: return "#9E9E9E"
        case .uncommon: return "#4CAF50"
        case .rare: return "#2196F3"
        case .epic: return "#9C27B0"
        case .legendary: return "#FFD700"
        }
    }
}

enum CollectibleCategory: String, Codable, CaseIterable {
    case distance = "Distance"
    case activities = "Activities"
    case goals = "Goals"
    case special = "Special"
    case seasonal = "Seasonal"
}

struct CollectibleRequirement: Codable {
    var type: RequirementType
    var value: Double
    var description: String
}

enum RequirementType: String, Codable {
    case totalDistance = "TotalDistance"
    case activityCount = "ActivityCount"
    case streak = "Streak"
    case specificActivity = "SpecificActivity"
    case goalCompletion = "GoalCompletion"
}
