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
