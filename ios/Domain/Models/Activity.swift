import Foundation
import CoreLocation

protocol Activity: Identifiable {
    var id: String { get }
    var activityType: ActivityType { get }
    var distance: Double { get }
    var movingTime: TimeInterval { get }
    var startDate: Date { get }
    var endDate: Date { get }
    var coordinates: [CLLocation] { get }
    var splits: [Split] { get }
    var stepCount: Int? { get }
    var activeCalories: Double { get }
    var totalElevationGain: Double { get }
}

struct ActivityIdentifier: Identifiable, Hashable {
    let activity: any Activity
    
    var id: String { activity.id }
    
    init(_ activity: any Activity) {
        self.activity = activity
    }
    
    static func == (lhs: ActivityIdentifier, rhs: ActivityIdentifier) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct RunningActivity: Activity, Hashable, Equatable {
    let id: String
    let activityType: ActivityType
    let distance: Double
    let movingTime: TimeInterval
    let startDate: Date
    let endDate: Date
    let coordinates: [CLLocation]
    let splits: [Split]
    let stepCount: Int?
    let activeCalories: Double
    let totalElevationGain: Double

    var averageSpeed: Double {
        guard movingTime > 0 else { return 0 }
        return distance / movingTime
    }

    var pace: TimeInterval {
        guard distance > 0 else { return 0 }
        return movingTime / (distance / 1000)
    }

    static func == (lhs: RunningActivity, rhs: RunningActivity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// Route model
struct Route: Identifiable, Codable {
    let id: String
    let name: String
    let coordinates: [Coordinate]
    let distance: Double
    let type: RouteType
}

/// Coordinate point
struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
    let elevation: Double

    init(latitude: Double, longitude: Double, elevation: Double = 0.0) {
        self.latitude = latitude
        self.longitude = longitude
        self.elevation = elevation
    }
}

/// Route type
enum RouteType: String, Codable {
    case loop = "LOOP"
    case outAndBack = "OUT_AND_BACK"
    case pointToPoint = "POINT_TO_POINT"
}
