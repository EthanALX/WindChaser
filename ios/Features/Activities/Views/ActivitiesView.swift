import SwiftUI

struct ActivitiesView: View {
    @StateObject private var viewModel = ActivitiesViewModel()
    @State private var selectedActivity: RunningActivity?
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
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
            .navigationDestination(for: RunningActivity.self) { activity in
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

    @State private var showingActionSheet = false
    @State private var actionSheetActivity: RunningActivity?

    private func showActionSheet(for activity: RunningActivity) {
        actionSheetActivity = activity
        showingActionSheet = true
    }

    private func handleEdit() {
        // TODO: Navigate to edit view
    }

    private func handleDelete() {
        guard let activity = actionSheetActivity else { return }
        viewModel.deleteActivity(id: activity.id)
    }
}

struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
    }
}
