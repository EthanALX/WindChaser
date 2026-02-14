import Foundation
import Combine

final class ActivitiesViewModel: ObservableObject {
    @Published var selectedPeriod: TimePeriod = .recent
    @Published var selectedDimension: StatDimension = .distance
    @Published var activities: [RunningActivity] = []
    @Published var statistics: ActivityStatistics = .empty

    private var cancellables = Set<AnyCancellable>()

    init() {
        loadSampleData()
        setupBindings()
    }

    private func setupBindings() {
        Publishers.CombineLatest(
            $selectedPeriod,
            $selectedDimension
        )
        .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
        .sink { [weak self] period, dimension in
            self?.updateStatistics(for: period)
        }
        .store(in: &cancellables)
    }

    private func updateStatistics(for period: TimePeriod) {
        let filteredActivities = filterActivities(for: period)
        statistics = calculateStatistics(from: filteredActivities)
    }

    private func filterActivities(for period: TimePeriod) -> [RunningActivity] {
        let calendar = Calendar.current
        let now = Date()

        switch period {
        case .recent:
            return Array(activities.sorted { $0.startDate > $1.startDate }.prefix(10))
        case .thisWeek:
            let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            return activities.filter { $0.startDate >= weekStart }
        case .month:
            let monthStart = calendar.dateInterval(of: .month, for: now)?.start ?? now
            return activities.filter { $0.startDate >= monthStart }
        case .year:
            let yearStart = calendar.dateInterval(of: .year, for: now)?.start ?? now
            return activities.filter { $0.startDate >= yearStart }
        case .allTime:
            return activities
        }
    }

    private func calculateStatistics(from activities: [RunningActivity]) -> ActivityStatistics {
        guard !activities.isEmpty else { return .empty }

        let totalDistance = activities.reduce(0) { $0 + $1.distance }
        let totalDuration = activities.reduce(0) { $0 + $1.movingTime }
        let totalCalories = activities.reduce(0) { $0 + Double($1.activeCalories) }
        let count = activities.count

        let avgPace = totalDistance > 0 ? totalDuration / (totalDistance) : 0

        return ActivityStatistics(
            totalDuration: totalDuration,
            totalDistance: totalDistance,
            avgPace: avgPace,
            activityCount: count,
            totalElevation: 0, // RunningActivity doesn't have elevation
            totalCalories: totalCalories,
            avgCadence: 181, // Mock value - not in RunningActivity
            avgStride: 100     // Mock value - not in RunningActivity
        )
    }

    private func loadSampleData() {
        activities = [
            RunningActivity(
                id: "1",
                activityType: .run,
                distance: 21120,
                movingTime: 7200,
                startDate: Date(),
                endDate: Date().addingTimeInterval(7200),
                coordinates: [],
                splits: [],
                stepCount: 6000,
                activeCalories: 800,
                totalElevationGain: 50
            ),
            RunningActivity(
                id: "2",
                activityType: .run,
                distance: 20260,
                movingTime: 6840,
                startDate: Date().addingTimeInterval(-86400),
                endDate: Date().addingTimeInterval(-79560),
                coordinates: [],
                splits: [],
                stepCount: 5800,
                activeCalories: 750,
                totalElevationGain: 40
            )
        ]
    }

    func deleteActivity(id: String) {
        activities.removeAll { $0.id == id }
        updateStatistics(for: selectedPeriod)
    }
}

struct ActivityStatistics {
    let totalDuration: TimeInterval
    let totalDistance: Double
    let avgPace: Double
    let activityCount: Int
    let totalElevation: Double
    let totalCalories: Double
    let avgCadence: Int
    let avgStride: Double

    static let empty = ActivityStatistics(
        totalDuration: 0,
        totalDistance: 0,
        avgPace: 0,
        activityCount: 0,
        totalElevation: 0,
        totalCalories: 0,
        avgCadence: 0,
        avgStride: 0
    )
}

extension Array {
    func Array() -> [Element] { self }
}
