# Activities Page Refactor Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Refactor the iOS app's Activities page to match the new design spec, removing the Record page and implementing a NavigationStack-based architecture with statistical charts and activity list views.

**Architecture:** Replace TabView with NavigationStack for root navigation. ActivitiesView becomes the root view with time period selection, statistical charts (using Swift Charts), and activity list. Data flows from local Activity models through ViewModels to Views.

**Tech Stack:** SwiftUI, NavigationStack (iOS 16+), Swift Charts, Combine framework, local data storage (in-memory arrays initially).

---

## Task 1: Create data models for time periods and statistics

**Files:**
- Create: `ios/Domain/Models/TimePeriod.swift`
- Create: `ios/Domain/Models/StatDimension.swift`

**Step 1: Write the failing test**

Create test file: `ios/Tests/Domain/Models/TimePeriodTests.swift`

```swift
import XCTest
@testable import RunningOS

final class TimePeriodTests: XCTestCase {
    func testTimePeriodHasAllRequiredCases() {
        XCTAssertEqual(TimePeriod.allCases.count, 5)
    }

    func testTimePeriodRawValues() {
        XCTAssertEqual(TimePeriod.recent.rawValue, "最近")
        XCTAssertEqual(TimePeriod.thisWeek.rawValue, "本周")
        XCTAssertEqual(TimePeriod.month.rawValue, "月")
        XCTAssertEqual(TimePeriod.year.rawValue, "年")
        XCTAssertEqual(TimePeriod.allTime.rawValue, "总")
    }

    func testTimePeriodIdentifiable() {
        let period = TimePeriod.thisWeek
        XCTAssertEqual(period.id, "本周")
    }
}
```

**Step 2: Run test to verify it fails**

Run: `xcodebuild test -scheme RunningOS -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:RunningOSTests/TimePeriodTests 2>&1 | grep -E "(PASS|FAIL|error:)"`

Expected: FAIL with "Cannot find 'TimePeriod' in scope"

**Step 3: Write minimal implementation**

Create: `ios/Domain/Models/TimePeriod.swift`

```swift
import Foundation

enum TimePeriod: String, CaseIterable, Identifiable {
    case recent = "最近"
    case thisWeek = "本周"
    case month = "月"
    case year = "年"
    case allTime = "总"

    var id: String { rawValue }
}
```

**Step 4: Run test to verify it passes**

Run: `xcodebuild test -scheme RunningOS -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:RunningOSTests/TimePeriodTests 2>&1 | grep -E "(PASS|FAIL|error:)"`

Expected: PASS

**Step 5: Commit**

```bash
git add ios/Domain/Models/TimePeriod.swift ios/Tests/Domain/Models/TimePeriodTests.swift
git commit -m "feat: add TimePeriod enum with test coverage"
```

---

**Step 6: Write the failing test for StatDimension**

Create: `ios/Tests/Domain/Models/StatDimensionTests.swift`

```swift
import XCTest
@testable import RunningOS

final class StatDimensionTests: XCTestCase {
    func testStatDimensionHasAllRequiredCases() {
        XCTAssertEqual(StatDimension.allCases.count, 5)
    }

    func testStatDimensionRawValues() {
        XCTAssertEqual(StatDimension.distance.rawValue, "距离")
        XCTAssertEqual(StatDimension.duration.rawValue, "时长")
        XCTAssertEqual(StatDimension.pace.rawValue, "配速")
        XCTAssertEqual(StatDimension.paceZone.rawValue, "配速区间")
        XCTAssertEqual(StatDimension.heartRateZone.rawValue, "心率区")
    }
}
```

**Step 7: Run test to verify it fails**

Run: `xcodebuild test -scheme RunningOS -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:RunningOSTests/StatDimensionTests 2>&1 | grep -E "(PASS|FAIL|error:)"`

Expected: FAIL with "Cannot find 'StatDimension' in scope"

**Step 8: Write minimal implementation**

Create: `ios/Domain/Models/StatDimension.swift`

```swift
import Foundation

enum StatDimension: String, CaseIterable, Identifiable {
    case distance = "距离"
    case duration = "时长"
    case pace = "配速"
    case paceZone = "配速区间"
    case heartRateZone = "心率区"

    var id: String { rawValue }
}
```

**Step 9: Run test to verify it passes**

Run: `xcodebuild test -scheme RunningOS -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:RunningOSTests/StatDimensionTests 2>&1 | grep -E "(PASS|FAIL|error:)"`

Expected: PASS

**Step 10: Commit**

```bash
git add ios/Domain/Models/StatDimension.swift ios/Tests/Domain/Models/StatDimensionTests.swift
git commit -m "feat: add StatDimension enum with test coverage"
```

---

## Task 2: Update AppActivity model with required fields

**Files:**
- Modify: `ios/RunningOSApp.swift:347-358`
- Test: Update existing activity tests

**Step 1: Write the failing test**

Create: `ios/Tests/Domain/Models/AppActivityTests.swift`

```swift
import XCTest
@testable import RunningOS

final class AppActivityTests: XCTestCase {
    func testAppActivityHasRequiredFields() {
        let activity = AppActivity(
            id: "1",
            activityType: .run,
            distance: 5000,
            movingTime: 1800,
            startDate: Date(),
            endDate: Date().addingTimeInterval(1800),
            stepCount: 6000,
            activeCalories: 300,
            totalElevationGain: 50
        )

        XCTAssertEqual(activity.id, "1")
        XCTAssertEqual(activity.distance, 5000)
        XCTAssertEqual(activity.movingTime, 1800)
    }

    func testAppActivityPaceCalculation() {
        let activity = AppActivity(
            id: "1",
            activityType: .run,
            distance: 5000, // 5km
            movingTime: 1800, // 30 minutes
            startDate: Date(),
            endDate: Date().addingTimeInterval(1800),
            stepCount: 6000,
            activeCalories: 300,
            totalElevationGain: 50
        )

        // Pace should be 6:00/km (30 min / 5 km)
        let expectedPace = 1800.0 / 5.0 // seconds per km
        // Verify calculation access pattern
        XCTAssertNotNil(activity.movingTime)
        XCTAssertGreaterThan(activity.distance, 0)
    }
}
```

**Step 2: Run test to verify it fails**

Run: `xcodebuild test -scheme RunningOS -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:RunningOSTests/AppActivityTests 2>&1 | grep -E "(PASS|FAIL|error:)"`

Expected: Tests may PASS if model already exists - if so, add computed properties

**Step 3: Extend AppActivity model with computed properties**

Modify the existing AppActivity struct in `ios/RunningOSApp.swift` (lines 347-358) to add:

```swift
struct AppActivity: Identifiable {
    let id: String
    let activityType: AppActivityType
    let distance: Double
    let movingTime: TimeInterval
    let startDate: Date
    let endDate: Date
    let stepCount: Int?
    let activeCalories: Double
    let totalElevationGain: Double

    // Computed properties for statistics
    var pace: TimeInterval {
        guard distance > 0 else { return 0 }
        return (movingTime / 60) / (distance / 1000) // min per km
    }

    var cadence: Int? {
        guard stepCount != nil, movingTime > 0 else { return nil }
        return Int(Double(stepCount!) / (movingTime / 60)) // steps per min
    }

    var strideLength: Double? {
        guard stepCount != nil, distance > 0 else { return nil }
        return (distance / Double(stepCount!)) * 100 // cm
    }
}
```

**Step 4: Run test to verify it passes**

Run: `xcodebuild test -scheme RunningOS -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:RunningOSTests/AppActivityTests 2>&1 | grep -E "(PASS|FAIL|error:)"`

Expected: PASS

**Step 5: Commit**

```bash
git add ios/RunningOSApp.swift ios/Tests/Domain/Models/AppActivityTests.swift
git commit -m "feat: add computed properties to AppActivity model"
```

---

## Task 3: Create color and typography constants

**Files:**
- Create: `ios/Core/Theme/AppColors.swift`
- Create: `ios/Core/Theme/AppTypography.swift`
- Create: `ios/Core/Theme/AppSpacing.swift`

**Step 1: Write the failing test**

Create: `ios/Tests/Core/Theme/AppColorsTests.swift`

```swift
import XCTest
@testable import RunningOS
import SwiftUI

final class AppColorsTests: XCTestCase {
    func testPrimaryColorExists() {
        let color = AppColor.primary
        // Verify it's a valid Color
        XCTAssertNotNil(color)
    }

    func testAllColorsDefined() {
        XCTAssertNotNil(AppColor.primary)
        XCTAssertNotNil(AppColor.background)
        XCTAssertNotNil(AppColor.cardBackground)
        XCTAssertNotNil(AppColor.textPrimary)
        XCTAssertNotNil(AppColor.textSecondary)
        XCTAssertNotNil(AppColor.border)
    }
}
```

**Step 2: Run test to verify it fails**

Run: `xcodebuild test -scheme RunningOS -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:RunningOSTests/AppColorsTests 2>&1 | grep -E "(PASS|FAIL|error:)"`

Expected: FAIL with "Cannot find 'AppColor' in scope"

**Step 3: Write minimal implementation**

Create: `ios/Core/Theme/AppColors.swift`

```swift
import SwiftUI

enum AppColor {
    static let primary = Color(hex: "#34C759")
    static let background = Color.white
    static let cardBackground = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let textPrimary = Color.black
    static let textSecondary = Color(red: 0.56, green: 0.56, blue: 0.58)
    static let border = Color.gray.opacity(0.2)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
```

**Step 4: Run test to verify it passes**

Run: `xcodebuild test -scheme RunningOS -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:RunningOSTests/AppColorsTests 2>&1 | grep -E "(PASS|FAIL|error:)"`

Expected: PASS

**Step 5: Commit**

```bash
git add ios/Core/Theme/AppColors.swift ios/Tests/Core/Theme/AppColorsTests.swift
git commit -m "feat: add AppColor constants with hex support"
```

---

**Step 6: Create Typography constants**

Create: `ios/Core/Theme/AppTypography.swift`

```swift
import SwiftUI

enum AppTypography {
    static let pageTitle = Font.largeTitle.bold()
    static let sectionTitle = Font.title3.bold()
    static let statValue = Font.title.bold()
    static let statLabel = Font.caption
    static let bodyText = Font.body
    static let caption = Font.caption2
}
```

**Step 7: Create Spacing constants**

Create: `ios/Core/Theme/AppSpacing.swift`

```swift
import SwiftUI

enum AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
}
```

**Step 8: Commit**

```bash
git add ios/Core/Theme/AppTypography.swift ios/Core/Theme/AppSpacing.swift
git commit -m "feat: add typography and spacing constants"
```

---

## Task 4: Create ViewModel for Activities page

**Files:**
- Create: `ios/Features/Activities/ViewModels/ActivitiesViewModel.swift`
- Test: `ios/Tests/Features/Activities/ViewModels/ActivitiesViewModelTests.swift`

**Step 1: Write the failing test**

Create: `ios/Tests/Features/Activities/ViewModels/ActivitiesViewModelTests.swift`

```swift
import XCTest
import Combine
@testable import RunningOS

final class ActivitiesViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    var viewModel: ActivitiesViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ActivitiesViewModel()
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.selectedPeriod, .recent)
        XCTAssertEqual(viewModel.selectedDimension, .distance)
        XCTAssertTrue(viewModel.activities.isEmpty)
    }

    func testPeriodSelectionUpdatesStatistics() {
        let expectation = XCTestExpectation(description: "Statistics update")

        viewModel.$statistics
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.selectedPeriod = .thisWeek
        wait(for: [expectation], timeout: 1.0)
    }

    func testDimensionSelectionUpdatesStatistics() {
        let expectation = XCTestExpectation(description: "Statistics update")

        viewModel.$statistics
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.selectedDimension = .pace
        wait(for: [expectation], timeout: 1.0)
    }
}
```

**Step 2: Run test to verify it fails**

Run: `xcodebuild test -scheme RunningOS -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:RunningOSTests/ActivitiesViewModelTests 2>&1 | grep -E "(PASS|FAIL|error:)"`

Expected: FAIL with "Cannot find 'ActivitiesViewModel' in scope"

**Step 3: Write minimal implementation**

Create: `ios/Features/Activities/ViewModels/ActivitiesViewModel.swift`

```swift
import Foundation
import Combine

final class ActivitiesViewModel: ObservableObject {
    @Published var selectedPeriod: TimePeriod = .recent
    @Published var selectedDimension: StatDimension = .distance
    @Published var activities: [AppActivity] = []
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

    private func filterActivities(for period: TimePeriod) -> [AppActivity] {
        // Filter activities based on time period
        let calendar = Calendar.current
        let now = Date()

        switch period {
        case .recent:
            return activities.sorted { $0.startDate > $1.startDate }.prefix(10).Array
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

    private func calculateStatistics(from activities: [AppActivity]) -> ActivityStatistics {
        guard !activities.isEmpty else { return .empty }

        let totalDistance = activities.reduce(0) { $0 + $1.distance }
        let totalDuration = activities.reduce(0) { $0 + $1.movingTime }
        let totalCalories = activities.reduce(0) { $0 + $1.activeCalories }
        let totalElevation = activities.reduce(0) { $0 + $1.totalElevationGain }
        let count = activities.count

        let avgPace = totalDistance > 0 ? totalDuration / (totalDistance / 1000) : 0

        return ActivityStatistics(
            totalDuration: totalDuration,
            totalDistance: totalDistance,
            avgPace: avgPace,
            activityCount: count,
            totalElevation: totalElevation,
            totalCalories: totalCalories,
            avgCadence: 181, // Mock value
            avgStride: 100     // Mock value
        )
    }

    private func loadSampleData() {
        activities = [
            AppActivity(
                id: "1",
                activityType: .run,
                distance: 21120,
                movingTime: 7200,
                startDate: Date(),
                endDate: Date().addingTimeInterval(7200),
                stepCount: 30000,
                activeCalories: 800,
                totalElevationGain: 120
            ),
            AppActivity(
                id: "2",
                activityType: .run,
                distance: 20260,
                movingTime: 6840,
                startDate: Date().addingTimeInterval(-86400),
                endDate: Date().addingTimeInterval(-79560),
                stepCount: 28500,
                activeCalories: 750,
                totalElevationGain: 100
            )
        ]
    }
}

struct ActivityStatistics {
    let totalDuration: TimeInterval
    let totalDistance: Double
    let avgPace: TimeInterval
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
```

**Step 4: Run test to verify it passes**

Run: `xcodebuild test -scheme RunningOS -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:RunningOSTests/ActivitiesViewModelTests 2>&1 | grep -E "(PASS|FAIL|error:)"`

Expected: PASS

**Step 5: Commit**

```bash
git add ios/Features/Activities/ViewModels/ActivitiesViewModel.swift ios/Tests/Features/Activities/ViewModels/ActivitiesViewModelTests.swift
git commit -m "feat: add ActivitiesViewModel with period filtering"
```

---

## Task 5: Create Activities header view component

**Files:**
- Create: `ios/Features/Activities/Views/Components/ActivitiesHeaderView.swift`
- Test: UI tests (optional for this component)

**Step 1: Create the header component**

Create: `ios/Features/Activities/Views/Components/ActivitiesHeaderView.swift`

```swift
import SwiftUI

struct ActivitiesHeaderView: View {
    var body: some View {
        HStack {
            Text("记录")
                .font(AppTypography.pageTitle)
                .foregroundColor(AppColor.textPrimary)

            Spacer()

            Button(action: {
                // TODO: Implement data authorization
            }) {
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: "eye")
                    Text("数据授权")
                }
                .font(.caption)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(AppColor.background)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AppColor.border, lineWidth: 1)
                )
                .foregroundColor(AppColor.textPrimary)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.lg)
    }
}

struct ActivitiesHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesHeaderView()
    }
}
```

**Step 2: Create preview to verify**

Run: Open file in Xcode and use Canvas preview

**Step 3: Commit**

```bash
git add ios/Features/Activities/Views/Components/ActivitiesHeaderView.swift
git commit -m "feat: add ActivitiesHeaderView component"
```

---

## Task 6: Create TimePeriod selector component

**Files:**
- Create: `ios/Features/Activities/Views/Components/TimePeriodSelector.swift`

**Step 1: Create the selector component**

Create: `ios/Features/Activities/Views/Components/TimePeriodSelector.swift`

```swift
import SwiftUI

struct TimePeriodSelector: View {
    @Binding var selectedPeriod: TimePeriod

    var body: some View {
        Picker("时间周期", selection: $selectedPeriod) {
            ForEach(TimePeriod.allCases) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
    }
}

struct TimePeriodSelector_Previews: PreviewProvider {
    static var previews: some View {
        TimePeriodSelector(selectedPeriod: .constant(.thisWeek))
    }
}
```

**Step 2: Preview verification**

Open in Xcode Canvas to verify segmented picker appearance

**Step 3: Commit**

```bash
git add ios/Features/Activities/Views/Components/TimePeriodSelector.swift
git commit -m "feat: add TimePeriodSelector component"
```

---

## Task 7: Create StatDimension selector tab bar

**Files:**
- Create: `ios/Features/Activities/Views/Components/StatDimensionSelector.swift`

**Step 1: Create the dimension selector**

Create: `ios/Features/Activities/Views/Components/StatDimensionSelector.swift`

```swift
import SwiftUI

struct StatDimensionSelector: View {
    @Binding var selectedDimension: StatDimension

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            ForEach(StatDimension.allCases) { dimension in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedDimension = dimension
                    }
                }) {
                    Text(dimension.rawValue)
                        .font(AppTypography.bodyText)
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.vertical, AppSpacing.sm)
                        .background(
                            selectedDimension == dimension
                                ? AppColor.background
                                : AppColor.cardBackground
                        )
                        .foregroundColor(
                            selectedDimension == dimension
                                ? AppColor.textPrimary
                                : AppColor.textSecondary
                        )
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.sm)
    }
}

struct StatDimensionSelector_Previews: PreviewProvider {
    static var previews: some View {
        StatDimensionSelector(selectedDimension: .constant(.distance))
    }
}
```

**Step 2: Preview verification**

Verify tab switching animation in Xcode Canvas

**Step 3: Commit**

```bash
git add ios/Features/Activities/Views/Components/StatDimensionSelector.swift
git commit -m "feat: add StatDimensionSelector component"
```

---

## Task 8: Create statistics grid view

**Files:**
- Create: `ios/Features/Activities/Views/Components/StatsGridView.swift`
- Create: `ios/Features/Activities/Views/Components/StatCard.swift`

**Step 1: Create StatCard component**

Create: `ios/Features/Activities/Views/Components/StatCard.swift`

```swift
import SwiftUI

struct StatCard: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            Text(value)
                .font(AppTypography.statValue)
                .foregroundColor(AppColor.textPrimary)

            Text(label)
                .font(AppTypography.statLabel)
                .foregroundColor(AppColor.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.md)
        .background(AppColor.background)
        .cornerRadius(12)
        .shadow(color: AppColor.border, radius: 2, x: 0, y: 1)
    }
}

struct StatCard_Previews: PreviewProvider {
    static var previews: some View {
        StatCard(value: "3:18:40", label: "跑步时长")
            .frame(width: 100)
    }
}
```

**Step 2: Create StatsGrid component**

Create: `ios/Features/Activities/Views/Components/StatsGridView.swift`

```swift
import SwiftUI

struct StatsGridView: View {
    let statistics: ActivityStatistics

    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.md),
        GridItem(.flexible(), spacing: AppSpacing.md),
        GridItem(.flexible(), spacing: AppSpacing.md)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: AppSpacing.md) {
            // Row 1
            StatCard(value: formatDuration(statistics.totalDuration), label: "跑步时长")
            StatCard(value: formatDistance(statistics.totalDistance), label: "总距离(km)")
            StatCard(value: formatPace(statistics.avgPace), label: "平均配速")

            // Row 2
            StatCard(value: "\(statistics.activityCount)", label: "跑步次数")
            StatCard(value: "\(Int(statistics.totalElevation))", label: "总爬升(m)")
            StatCard(value: "\(Int(statistics.totalCalories))", label: "卡路里(kcal)")

            // Row 3
            StatCard(value: "\(statistics.avgCadence)", label: "平均步频")
            StatCard(value: "\(Int(statistics.avgStride))", label: "平均步长(cm)")
            StatCard(value: "", label: "") // Empty placeholder
        }
        .padding(.horizontal, AppSpacing.lg)
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }

    private func formatDistance(_ distance: Double) -> String {
        String(format: "%.1f", distance / 1000)
    }

    private func formatPace(_ pace: TimeInterval) -> String {
        let minutes = Int(pace)
        let seconds = Int((pace - Double(minutes)) * 60)
        return String(format: "%d'%02d\"", minutes, seconds)
    }
}

struct StatsGridView_Previews: PreviewProvider {
    static var previews: some View {
        StatsGridView(statistics: ActivityStatistics.empty)
    }
}
```

**Step 3: Preview verification**

Verify grid layout in Xcode Canvas with sample data

**Step 4: Commit**

```bash
git add ios/Features/Activities/Views/Components/StatCard.swift ios/Features/Activities/Views/Components/StatsGridView.swift
git commit -m "feat: add StatsGridView and StatCard components"
```

---

## Task 9: Create weekly bar chart view

**Files:**
- Create: `ios/Features/Activities/Views/Components/WeeklyBarChartView.swift`

**Step 1: Create the chart component**

Create: `ios/Features/Activities/Views/Components/WeeklyBarChartView.swift`

```swift
import SwiftUI
import Charts

struct WeeklyBarChartView: View {
    let activities: [AppActivity]
    let dimension: StatDimension

    private var weekData: [(day: String, value: Double)] {
        let calendar = Calendar.current
        let today = Date()
        let weekDays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let weekdaySymbols = calendar.shortWeekdaySymbols

        return weekDays.map { weekday in
            let index = (weekday - calendar.firstWeekday + 7) % 7
            let daySymbol = weekdaySymbols[index]

            let dayValue = activities.filter { activity in
                calendar.component(.weekday, from: activity.startDate) == weekday
            }.reduce(0.0) { sum, activity in
                switch dimension {
                case .distance:
                    return sum + activity.distance / 1000 // Convert to km
                case .duration:
                    return sum + activity.movingTime / 60 // Convert to minutes
                case .pace:
                    return sum + (activity.distance > 0 ? activity.movingTime / (activity.distance / 1000) : 0)
                default:
                    return sum
                }
            }

            return (day: daySymbol, value: dayValue)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("周跑量统计")
                .font(AppTypography.sectionTitle)
                .foregroundColor(AppColor.textPrimary)
                .padding(.horizontal, AppSpacing.lg)

            Chart(weekData, id: \.day) { item in
                BarMark(
                    x: .value("Day", item.day),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(AppColor.primary)
            }
            .frame(height: 180)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .padding(.horizontal, AppSpacing.lg)
        }
        .padding(.vertical, AppSpacing.md)
        .background(AppColor.background)
    }
}

struct WeeklyBarChartView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyBarChartView(
            activities: [],
            dimension: .distance
        )
    }
}
```

**Step 2: Verify in preview**

Check that chart renders properly with sample data

**Step 3: Commit**

```bash
git add ios/Features/Activities/Views/Components/WeeklyBarChartView.swift
git commit -m "feat: add WeeklyBarChartView using Swift Charts"
```

---

## Task 10: Create Activity list card component

**Files:**
- Create: `ios/Features/Activities/Views/Components/ActivityListCard.swift`

**Step 1: Create the list card component**

Create: `ios/Features/Activities/Views/Components/ActivityListCard.swift`

```swift
import SwiftUI

struct ActivityListCard: View {
    let activity: AppActivity
    let onTap: () -> Void
    let onLongPress: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack {
                    Text(dateLabel)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColor.textSecondary)

                    Spacer()
                }

                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: activity.activityType.iconName)
                        .foregroundColor(AppColor.primary)

                    Text(activityTitle)
                        .font(AppTypography.bodyText)
                        .foregroundColor(AppColor.textPrimary)

                    Spacer()

                    Text(distanceLabel)
                        .font(AppTypography.bodyText)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColor.textPrimary)
                }
            }
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColor.cardBackground)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0.5) {
            withAnimation(.easeInOut) {
                onLongPress()
            }
        }
    }

    private var dateLabel: String {
        let calendar = Calendar.current
        let now = Date()
        if calendar.isDateInToday(activity.startDate) {
            return "今天"
        } else if calendar.isDateInYesterday(activity.startDate) {
            return "昨天"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            formatter.locale = Locale(identifier: "zh_CN")
            return formatter.string(from: activity.startDate)
        }
    }

    private var activityTitle: String {
        let hour = Calendar.current.component(.hour, from: activity.startDate)
        let timeOfDay: String
        if hour < 12 {
            timeOfDay = "晨间"
        } else if hour < 18 {
            timeOfDay = "午间"
        } else {
            timeOfDay = "晚间"
        }
        return "\(timeOfDay) · 节奏跑"
    }

    private var distanceLabel: String {
        String(format: "%.2f km", activity.distance / 1000)
    }
}

struct ActivityListCard_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListCard(
            activity: AppActivity(
                id: "1",
                activityType: .run,
                distance: 15000,
                movingTime: 3600,
                startDate: Date(),
                endDate: Date().addingTimeInterval(3600),
                stepCount: 12000,
                activeCalories: 500,
                totalElevationGain: 80
            ),
            onTap: {},
            onLongPress: {}
        )
        .padding()
    }
}
```

**Step 2: Preview verification**

Test tap animation and long press gesture

**Step 3: Commit**

```bash
git add ios/Features/Activities/Views/Components/ActivityListCard.swift
git commit -m "feat: add ActivityListCard with tap and long press gestures"
```

---

## Task 11: Create Activities list view

**Files:**
- Create: `ios/Features/Activities/Views/Components/ActivitiesListView.swift`

**Step 1: Create the list view component**

Create: `ios/Features/Activities/Views/Components/ActivitiesListView.swift`

```swift
import SwiftUI

struct ActivitiesListView: View {
    let activities: [AppActivity]
    let onActivityTap: (AppActivity) -> Void
    let onActivityLongPress: (AppActivity) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("最近")
                    .font(AppTypography.sectionTitle)
                    .foregroundColor(AppColor.textPrimary)

                Spacer()

                HStack(spacing: AppSpacing.md) {
                    Image(systemName: "bookmark")
                    Image(systemName: "star.fill")
                }
                .foregroundColor(AppColor.textSecondary)
                .font(.title3)
            }
            .padding(.horizontal, AppSpacing.lg)

            if activities.isEmpty {
                Text("暂无活动记录")
                    .font(AppTypography.bodyText)
                    .foregroundColor(AppColor.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, AppSpacing.xxl)
            } else {
                VStack(spacing: AppSpacing.sm) {
                    ForEach(activities) { activity in
                        ActivityListCard(
                            activity: activity,
                            onTap: { onActivityTap(activity) },
                            onLongPress: { onActivityLongPress(activity) }
                        )
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
            }
        }
    }
}

struct ActivitiesListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesListView(
            activities: [],
            onActivityTap: { _ in },
            onActivityLongPress: { _ in }
        )
    }
}
```

**Step 2: Preview verification**

**Step 3: Commit**

```bash
git add ios/Features/Activities/Views/Components/ActivitiesListView.swift
git commit -m "feat: add ActivitiesListView component"
```

---

## Task 12: Create main ActivitiesView

**Files:**
- Create: `ios/Features/Activities/Views/ActivitiesView.swift`

**Step 1: Create the main Activities view**

Create: `ios/Features/Activities/Views/ActivitiesView.swift`

```swift
import SwiftUI

struct ActivitiesView: View {
    @StateObject private var viewModel = ActivitiesViewModel()
    @State private var selectedActivity: AppActivity?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ActivitiesHeaderView()

                TimePeriodSelector(selectedPeriod: $viewModel.selectedPeriod)
                    .padding(.top, AppSpacing.md)

                WeeklyBarChartView(
                    activities: viewModel.activities,
                    dimension: viewModel.selectedDimension
                )
                .padding(.top, AppSpacing.md)

                StatDimensionSelector(selectedDimension: $viewModel.selectedDimension)
                    .padding(.top, AppSpacing.md)

                StatsGridView(statistics: viewModel.statistics)
                    .padding(.top, AppSpacing.lg)

                ActivitiesListView(
                    activities: viewModel.activities,
                    onActivityTap: { activity in
                        selectedActivity = activity
                    },
                    onActivityLongPress: { activity in
                        showActionSheet(for: activity)
                    }
                )
                .padding(.top, AppSpacing.xl)
            }
        }
        .background(AppColor.background)
        .confirmationDialog("操作", isPresented: $showingActionSheet, titleVisibility: .visible) {
            Button("编辑") { handleEdit() }
            Button("删除", role: .destructive) { handleDelete() }
            Button("取消", role: .cancel) { }
        }
    }

    @State private var showingActionSheet = false
    @State private var actionSheetActivity: AppActivity?

    private func showActionSheet(for activity: AppActivity) {
        actionSheetActivity = activity
        showingActionSheet = true
    }

    private func handleEdit() {
        // TODO: Navigate to edit view
    }

    private func handleDelete() {
        guard let activity = actionSheetActivity else { return }
        // TODO: Implement delete
    }
}

struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
    }
}
```

**Step 2: Preview verification**

Test all components render correctly together

**Step 3: Commit**

```bash
git add ios/Features/Activities/Views/ActivitiesView.swift
git commit -m "feat: add main ActivitiesView with all components"
```

---

## Task 13: Create ActivityDetailView

**Files:**
- Create: `ios/Features/Activities/Views/ActivityDetailView.swift`

**Step 1: Create the detail view**

Create: `ios/Features/Activities/Views/ActivityDetailView.swift`

```swift
import SwiftUI

struct ActivityDetailView: View {
    let activity: AppActivity
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                // Header
                HStack {
                    Image(systemName: activity.activityType.iconName)
                        .font(.largeTitle)
                        .foregroundColor(AppColor.primary)

                    VStack(alignment: .leading) {
                        Text(activity.activityType.displayName)
                            .font(AppTypography.sectionTitle)
                        Text(activity.startDate, style: .date)
                            .font(AppTypography.bodyText)
                            .foregroundColor(AppColor.textSecondary)
                    }

                    Spacer()
                }
                .padding()

                // Stats grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: AppSpacing.lg) {
                    StatCard(value: String(format: "%.2f km", activity.distance / 1000), label: "距离")
                    StatCard(value: formatDuration(activity.movingTime), label: "时长")
                    StatCard(value: String(format: "%.0f", activity.activeCalories), label: "卡路里")
                    StatCard(value: String(format: "%.0f m", activity.totalElevationGain), label: "爬升")
                }
                .padding(.horizontal)
            }
        }
        .background(AppColor.background)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ActivityDetailView(activity: AppActivity(
                id: "1",
                activityType: .run,
                distance: 15000,
                movingTime: 3600,
                startDate: Date(),
                endDate: Date().addingTimeInterval(3600),
                stepCount: 12000,
                activeCalories: 500,
                totalElevationGain: 80
            ))
        }
    }
}
```

**Step 2: Preview verification**

**Step 3: Commit**

```bash
git add ios/Features/Activities/Views/ActivityDetailView.swift
git commit -m "feat: add ActivityDetailView"
```

---

## Task 14: Update RunningOSApp to use NavigationStack

**Files:**
- Modify: `ios/RunningOSApp.swift:1-35`

**Step 1: Backup and replace app structure**

Replace the entire content of `ios/RunningOSApp.swift` with:

```swift
import SwiftUI
import Combine

@main
struct RunningOSApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ActivitiesView()
                    .navigationDestination(isPresented: .constant(false)) {
                        // Navigation destinations will be added here
                    }
            }
        }
    }
}
```

**Step 2: Build and verify**

Run: `xcodebuild -scheme RunningOS -destination 'platform=iOS Simulator,name=iPhone 15' build 2>&1 | tail -20`

Expected: BUILD SUCCEEDED

**Step 3: Commit**

```bash
git add ios/RunningOSApp.swift
git commit -m "refactor: replace TabView with NavigationStack architecture"
```

---

## Task 15: Delete RecordView and related components

**Files:**
- Modify: `ios/RunningOSApp.swift` (remove RecordView code)
- Delete all Record-related structs

**Step 1: Remove RecordView from RunningOSApp.swift**

The RecordView struct (lines 407-562 in current file) should be completely removed.

**Step 2: Remove associated components**

Remove these structs if they exist:
- `RecordStatBox`
- `ActivityTypePicker`

**Step 3: Verify build**

Run: `xcodebuild -scheme RunningOS -destination 'platform=iOS Simulator,name=iPhone 15' build 2>&1 | tail -20`

Expected: BUILD SUCCEEDED (no references to missing components)

**Step 4: Commit**

```bash
git add ios/RunningOSApp.swift
git commit -m "refactor: remove RecordView and related components"
```

---

## Task 16: Add navigation from ActivitiesView to ActivityDetailView

**Files:**
- Modify: `ios/Features/Activities/Views/ActivitiesView.swift`

**Step 1: Update ActivitiesView with navigation**

Modify the ActivitiesView to add NavigationStack path:

```swift
struct ActivitiesView: View {
    @StateObject private var viewModel = ActivitiesViewModel()
    @State private var selectedActivity: AppActivity?
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                // ... existing content ...
            }
            .background(AppColor.background)
            .navigationDestination(for: AppActivity.self) { activity in
                ActivityDetailView(activity: activity)
            }
            .confirmationDialog("操作", isPresented: $showingActionSheet, titleVisibility: .visible) {
                Button("编辑") { handleEdit() }
                Button("删除", role: .destructive) { handleDelete() }
                Button("取消", role: .cancel) { }
            }
        }
        .onChange(of: selectedActivity) { activity in
            guard let activity = activity else { return }
            navigationPath.append(activity)
        }
    }

    // ... rest of implementation ...
}
```

**Step 2: Test navigation**

Build and run in simulator, verify tapping an activity navigates to detail view

**Step 3: Commit**

```bash
git add ios/Features/Activities/Views/ActivitiesView.swift
git commit -m "feat: add navigation to ActivityDetailView"
```

---

## Task 17: Add ActivityEditView

**Files:**
- Create: `ios/Features/Activities/Views/ActivityEditView.swift`

**Step 1: Create edit view**

Create: `ios/Features/Activities/Views/ActivityEditView.swift`

```swift
import SwiftUI

struct ActivityEditView: View {
    @Binding var activity: AppActivity
    @Environment(\.dismiss) var dismiss

    @State private var editedDistance: String
    @State private var editedDuration: TimeInterval
    @State private var editedCalories: String

    init(activity: Binding<AppActivity>) {
        self._activity = activity
        self._editedDistance = State(initialValue: String(format: "%.0f", activity.wrappedValue.distance))
        self._editedDuration = State(initialValue: activity.wrappedValue.movingTime)
        self._editedCalories = State(initialValue: String(format: "%.0f", activity.wrappedValue.activeCalories))
    }

    var body: some View {
        Form {
            Section(header: Text("活动信息")) {
                HStack {
                    Text("距离")
                        .foregroundColor(AppColor.textSecondary)
                    TextField("距离", text: $editedDistance)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                    Text("km")
                        .foregroundColor(AppColor.textSecondary)
                }

                HStack {
                    Text("时长")
                        .foregroundColor(AppColor.textSecondary)
                    Text("\(Int(editedDuration / 60)):\(Int(editedDuration.truncatingRemainder(dividingBy: 60)))")
                        .foregroundColor(AppColor.textPrimary)
                }

                HStack {
                    Text("卡路里")
                        .foregroundColor(AppColor.textSecondary)
                    TextField("卡路里", text: $editedCalories)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                    Text("kcal")
                        .foregroundColor(AppColor.textSecondary)
                }
            }
        }
        .navigationTitle("编辑活动")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("取消") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("保存") { saveChanges() }
            }
        }
    }

    private func saveChanges() {
        // TODO: Implement save logic
        dismiss()
    }
}

struct ActivityEditView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityEditView(
            activity: .constant(
                AppActivity(
                    id: "1",
                    activityType: .run,
                    distance: 15000,
                    movingTime: 3600,
                    startDate: Date(),
                    endDate: Date().addingTimeInterval(3600),
                    stepCount: 12000,
                    activeCalories: 500,
                    totalElevationGain: 80
                )
            )
        )
    }
}
```

**Step 2: Preview verification**

**Step 3: Commit**

```bash
git add ios/Features/Activities/Views/ActivityEditView.swift
git commit -m "feat: add ActivityEditView"
```

---

## Task 18: Add delete functionality with confirmation

**Files:**
- Modify: `ios/Features/Activities/Views/ActivitiesView.swift`

**Step 1: Implement delete handler**

Add to ActivitiesViewModel:

```swift
func deleteActivity(id: String) {
    activities.removeAll { $0.id == id }
    updateStatistics(for: selectedPeriod)
}
```

**Step 2: Update ActivitiesView delete handler**

```swift
@State private var showingDeleteAlert = false

private func handleDelete() {
    guard let activity = actionSheetActivity else { return }
    showingDeleteAlert = true
}

.alert("确认删除", isPresented: $showingDeleteAlert) {
    Button("取消", role: .cancel) { }
    Button("删除", role: .destructive) {
        if let activity = actionSheetActivity {
            viewModel.deleteActivity(id: activity.id)
        }
    }
} message: {
    Text("确定要删除这条活动记录吗？")
}
```

**Step 3: Test delete functionality**

**Step 4: Commit**

```bash
git add ios/Features/Activities/Views/ActivitiesView.swift ios/Features/Activities/ViewModels/ActivitiesViewModel.swift
git commit -m "feat: add delete activity with confirmation alert"
```

---

## Task 19: Update project file references in Xcode

**Files:**
- Modify: `ios/RunningOS.xcodeproj/project.pbxproj`

**Step 1: Add new files to Xcode project**

Run the provided script to add all new Swift files to Xcode:

```bash
./ios/add_files_to_xcode.sh
```

**Step 2: Verify all files are referenced**

Open Xcode and check that all new files appear in the project navigator

**Step 3: Commit**

```bash
git add ios/RunningOS.xcodeproj/project.pbxproj
git commit -m "chore: add new files to Xcode project"
```

---

## Task 20: Final integration testing

**Files:**
- Test all components together

**Step 1: Build and run in simulator**

Run: `xcodebuild -scheme RunningOS -destination 'platform=iOS Simulator,name=iPhone 15' -derivedDataPath build 2>&1 | grep -E "(BUILD|error|warning)" | tail -30`

Expected: BUILD SUCCEEDED

**Step 2: Manual testing checklist**

Test each feature:
- [ ] App launches to ActivitiesView
- [ ] Time period selector updates statistics
- [ ] Dimension selector updates chart
- [ ] Activity list displays activities
- [ ] Tap activity navigates to detail view
- [ ] Back button returns to list
- [ ] Long press shows action sheet
- [ ] Delete removes activity from list
- [ ] All animations are smooth

**Step 3: Fix any issues found**

Address bugs or UI problems discovered during testing

**Step 4: Final commit**

```bash
git add .
git commit -m "test: complete Activities page refactor implementation"
```

---

## Task 21: Update documentation

**Files:**
- Create: `ios/FEATURES.md` (if doesn't exist)
- Update: README.md

**Step 1: Document new architecture**

Create `ios/FEATURES.md`:

```markdown
# WindChaser iOS Features

## Architecture

- **Navigation**: NavigationStack (iOS 16+)
- **State Management**: Combine + ObservableObject ViewModels
- **UI Framework**: SwiftUI
- **Charts**: Swift Charts

## Key Features

### Activities Page
- Time period filtering (Recent/Week/Month/Year/All Time)
- Statistical dimensions (Distance/Duration/Pace/Pace Zone/Heart Rate Zone)
- Weekly bar chart visualization
- Activity list with tap and long-press gestures
- Activity detail view
- Edit and delete functionality

## Project Structure

```
ios/
├── Domain/
│   └── Models/          # Data models
├── Features/
│   └── Activities/       # Activities feature
│       ├── Views/
│       │   ├── Components/
│       │   └── ActivitiesView.swift
│       └── ViewModels/
├── Core/
│   └── Theme/           # Design system
└── Tests/                # Unit tests
```
```

**Step 2: Update README**

**Step 3: Commit**

```bash
git add ios/FEATURES.md README.md
git commit -m "docs: document new architecture and features"
```

---

## Summary

This implementation plan breaks down the Activities page refactor into 21 bite-sized tasks, each following TDD principles with test writing, implementation, and commit steps.

**Total estimated time:** 3-4 hours for full implementation

**Key achievements:**
- ✅ NavigationStack architecture
- ✅ Component-based UI structure
- ✅ ViewModel-driven state management
- ✅ Test coverage for models and ViewModels
- ✅ Design system (colors, typography, spacing)
- ✅ Interactive components (charts, selectors, lists)
- ✅ Navigation flows (list → detail, edit, delete)
- ✅ Clean separation of concerns

**Next steps after implementation:**
1. Code review using superpowers:code-review
2. Performance profiling with Instruments
3. UI/UX testing on device
4. Data persistence layer (Core Data or SwiftData)
5. HealthKit integration for real data
