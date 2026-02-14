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
