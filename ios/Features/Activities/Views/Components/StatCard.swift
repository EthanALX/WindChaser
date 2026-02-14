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
