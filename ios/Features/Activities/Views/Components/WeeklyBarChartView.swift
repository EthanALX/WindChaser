import SwiftUI

struct WeeklyBarChartView: View {
    let activities: [RunningActivity]
    let dimension: StatDimension

    private var weekData: [(day: String, value: Double)] {
        let calendar = Calendar.current
        let weekdaySymbols = calendar.shortWeekdaySymbols

        // Generate Monday to Sunday data
        var data: [(day: String, value: Double)] = []

        for i in 0..<7 {
            let weekday = (i + 1) % 7
            let index = (weekday + calendar.firstWeekday - 1) % 7
            let daySymbol = weekdaySymbols[index]

            let dayValue = activities.filter { activity in
                calendar.component(.weekday, from: activity.startDate) == weekday
            }.reduce(0.0) { sum, activity in
                switch dimension {
                case .distance:
                    return sum + activity.distance / 1000
                case .duration:
                    return sum + activity.movingTime / 60
                case .pace:
                    return sum + (activity.distance > 0 ? activity.movingTime / (activity.distance / 1000) : 0)
                default:
                    return sum
                }
            }

            data.append((day: daySymbol, value: dayValue))
        }

        return data
    }

    private var maxValue: Double {
        let values = weekData.map { $0.value }
        return values.max() ?? 1.0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            // Title
            Text("周跑量统计")
                .font(AppTypography.sectionTitle)
                .foregroundColor(AppColor.textPrimary)
                .padding(.horizontal, AppSpacing.lg)

            // Bar chart
            HStack(alignment: .bottom, spacing: AppSpacing.sm) {
                ForEach(weekData, id: \.day) { item in
                    BarView(
                        value: item.value,
                        maxValue: maxValue,
                        day: item.day
                    )
                }
            }
            .frame(height: 180)
            .padding(.horizontal, AppSpacing.lg)

            // X-axis labels
            HStack(spacing: 0) {
                ForEach(weekData, id: \.day) { item in
                    Text(item.day)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColor.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, AppSpacing.lg)
        }
        .padding(.vertical, AppSpacing.md)
        .background(AppColor.background)
    }
}

// Single bar view
struct BarView: View {
    let value: Double
    let maxValue: Double
    let day: String

    private var barHeight: CGFloat {
        guard maxValue > 0 else { return 0 }
        let ratio = value / maxValue
        return max(20, CGFloat(ratio * 140))
    }

    var body: some View {
        VStack(spacing: 4) {
            // Bar rectangle
            Rectangle()
                .fill(AppColor.primary)
                .frame(width: 30, height: barHeight)
                .cornerRadius(4)

            // Value label on top of bar
            if value > 0 {
                Text(formatValue(value))
                    .font(AppTypography.caption)
                    .foregroundColor(AppColor.textSecondary)
            }
        }
    }

    private func formatValue(_ value: Double) -> String {
        if value == 0 { return "" }
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.1f", value)
        } else {
            return String(format: "%.0f", value)
        }
    }
}

struct WeeklyBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            WeeklyBarChartView(
                activities: [
                    RunningActivity(
                        id: "preview",
                        activityType: .run,
                        distance: 5000,
                        movingTime: 1800,
                        startDate: Date(),
                        endDate: Date().addingTimeInterval(1800),
                        coordinates: [],
                        splits: [],
                        stepCount: 1500,
                        activeCalories: 300,
                        totalElevationGain: 20
                    )
                ],
                dimension: .distance
            )

            Text("Pure SwiftUI, no Charts framework dependency")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding()
        }
    }
}
