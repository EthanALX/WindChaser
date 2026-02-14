import Foundation

enum StatDimension: String, CaseIterable, Identifiable {
    case distance = "距离"
    case duration = "时长"
    case pace = "配速"
    case paceZone = "配速区间"
    case heartRateZone = "心率区"

    var id: String { rawValue }
}
