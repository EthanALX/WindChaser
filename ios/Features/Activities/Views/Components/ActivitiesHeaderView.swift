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
