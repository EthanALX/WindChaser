import SwiftUI

struct ActivitiesListView: View {
    let activities: [RunningActivity]
    let onActivityTap: (RunningActivity) -> Void
    let onActivityLongPress: (RunningActivity) -> Void

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
