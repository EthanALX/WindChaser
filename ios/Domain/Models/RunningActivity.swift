import Foundation

// MARK: - Domain Models

/// 跑步活动领域模型
struct RunningActivity: Identifiable, Codable {
    let id: String
    let name: String
    let distance: Double        // 公里
    let duration: TimeInterval  // 秒
    let pace: Double            // 分钟/公里
    let calories: Int
    let timestamp: Date
    let route: Route?

    var formattedPace: String {
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
    }
}

/// 路线模型
struct Route: Identifiable, Codable {
    let id: String
    let name: String
    let coordinates: [Coordinate]
    let distance: Double
    let type: RouteType
}

/// 坐标点
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

/// 路线类型
enum RouteType: String, Codable {
    case loop = "LOOP"
    case outAndBack = "OUT_AND_BACK"
    case pointToPoint = "POINT_TO_POINT"
}

/// 用户统计数据
struct UserStats {
    let totalDistance: Double     // 总距离 (公里)
    let totalRuns: Int            // 总跑步次数
    let totalMarathons: Int       // 完成马拉松数量
    let avgPace: Double           // 平均配速 (分钟/公里)
    let activeDays: Int           // 活跃天数
    let personalBests: PersonalBests
}

/// 个人最佳成绩
struct PersonalBests {
    let fiveK: String?           // 5K 最佳成绩
    let tenK: String?            // 10K 最佳成绩
    let halfMarathon: String?    // 半马最佳成绩
    let marathon: String?        // 全马最佳成绩
}
