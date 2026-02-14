import Foundation

enum TimePeriod: String, CaseIterable, Identifiable {
    case recent = "最近"
    case thisWeek = "本周"
    case month = "月"
    case year = "年"
    case allTime = "总"

    var id: String { rawValue }
}
