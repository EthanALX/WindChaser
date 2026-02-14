import Foundation

struct Split: Codable, Equatable, Hashable {
    let unit: DistanceUnit
    let startDate: Date
    var duration: TimeInterval
    let startDistanceMeters: Double
    var totalDistanceMeters: Double
    var isPartial: Bool
    
    var currentSplitDistanceMeters: Double {
        return totalDistanceMeters - startDistanceMeters
    }

    var endDate: Date {
        return startDate.addingTimeInterval(duration)
    }
    
    var avgSpeedInUnit: Double {
        let distanceInUnit = unit.convert(meters: currentSplitDistanceMeters)
        let hours = duration / 3600
        guard hours > 0 else { return 0 }
        return distanceInUnit / hours
    }
    
    init(unit: DistanceUnit, startDate: Date, duration: TimeInterval, startDistanceMeters: Double, totalDistanceMeters: Double, isPartial: Bool = false) {
        self.unit = unit
        self.startDate = startDate
        self.duration = duration
        self.startDistanceMeters = startDistanceMeters
        self.totalDistanceMeters = totalDistanceMeters
        self.isPartial = isPartial
    }
    
    func completedIfPartial() -> Split {
        guard isPartial else { return self }
        
        var completedSplit = self
        let fullSplitDistanceMeters = unit.toMeters(value: 1)
        completedSplit.duration = duration * (fullSplitDistanceMeters / currentSplitDistanceMeters)
        completedSplit.totalDistanceMeters = completedSplit.startDistanceMeters + fullSplitDistanceMeters
        completedSplit.isPartial = false
        return completedSplit
    }
}
