import Foundation

struct User: Identifiable, Codable {
    let id: String
    var name: String
    var email: String
    var distanceUnit: DistanceUnit
    var signupDate: Date?
    var friendIDs: [String]
    
    static var current: User = User(
        id: UUID().uuidString,
        name: "Runner",
        email: "",
        distanceUnit: .miles,
        signupDate: Date(),
        friendIDs: []
    )
    
    var displayName: String {
        return name.isEmpty ? "Runner" : name
    }
}

struct UserStats: Codable {
    var totalDistance: Double
    var totalRuns: Int
    var totalMarathons: Int
    var avgPace: Double
    var activeDays: Int
    var personalBests: PersonalBests
    
    static var empty: UserStats {
        UserStats(
            totalDistance: 0,
            totalRuns: 0,
            totalMarathons: 0,
            avgPace: 0,
            activeDays: 0,
            personalBests: PersonalBests()
        )
    }
}

struct PersonalBests: Codable {
    var fiveK: String?
    var tenK: String?
    var halfMarathon: String?
    var marathon: String?
    
    init(fiveK: String? = nil, tenK: String? = nil, halfMarathon: String? = nil, marathon: String? = nil) {
        self.fiveK = fiveK
        self.tenK = tenK
        self.halfMarathon = halfMarathon
        self.marathon = marathon
    }
}
