import SwiftUI
import Combine

@main
struct RunningOSApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ActivitiesView()
            }
        }
    }
}


struct ProfileView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    AppProfileHeader()
                    AppStatsSection()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Quick Actions")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(spacing: 8) {
                            NavigationLink(destination: GoalsView()) {
                                QuickActionRow(icon: "target", title: "Goals", color: .green)
                            }
                            
                            NavigationLink(destination: AchievementsView()) {
                                QuickActionRow(icon: "trophy.fill", title: "Achievements", color: .yellow)
                            }
                            
                            NavigationLink(destination: SettingsView()) {
                                QuickActionRow(icon: "gearshape.fill", title: "Settings", color: .gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(16)
                }
                .padding()
            }
            .navigationTitle("Profile")
        }
    }
}

struct QuickActionRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

struct AppProfileHeader: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Runner")
                .font(.title)
                .fontWeight(.bold)
            
            Text("runner@example.com")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
    }
}

struct AppStatsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Statistics")
                .font(.title2)
                .fontWeight(.bold)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                AppProfileStatBox(title: "Total Distance", value: "25.5 km", icon: "ruler")
                AppProfileStatBox(title: "Activities", value: "12", icon: "figure.run")
                AppProfileStatBox(title: "Active Days", value: "8", icon: "calendar")
                AppProfileStatBox(title: "Calories", value: "3,240", icon: "flame")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
    }
}

struct AppProfileStatBox: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct AppGoalsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Goals")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("No active goals")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
    }
}

// Models
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
}

enum AppActivityType: String, CaseIterable {
    case run = "Run"
    case bikeRide = "Ride"
    case walk = "Walk"
    case swim = "Swim"
    case hike = "Hike"
    
    var displayName: String {
        switch self {
        case .run: return "Run"
        case .bikeRide: return "Bike Ride"
        case .walk: return "Walk"
        case .swim: return "Swim"
        case .hike: return "Hike"
        }
    }
    
    var iconName: String {
        switch self {
        case .run: return "figure.run"
        case .bikeRide: return "figure.outdoor.cycle"
        case .walk: return "figure.walk"
        case .swim: return "figure.pool.swim"
        case .hike: return "figure.hiking"
        }
    }
}

struct AppGoal: Identifiable {
    let id: String
    let title: String
    let target: Double
    let current: Double
    let unit: String
    let icon: String
    let color: Color
}

struct AppAchievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let isUnlocked: Bool
    let color: Color
}

struct GoalsView: View {
    @State private var goals: [AppGoal] = [
        AppGoal(id: "1", title: "Weekly Distance", target: 25, current: 18.5, unit: "km", icon: "ruler", color: .blue),
        AppGoal(id: "2", title: "Monthly Activities", target: 20, current: 12, unit: "activities", icon: "figure.run", color: .green),
        AppGoal(id: "3", title: "Calories Burned", target: 5000, current: 3240, unit: "kcal", icon: "flame", color: .orange)
    ]
    
    var body: some View {
        List {
            Section(header: Text("Active Goals")) {
                ForEach(goals) { goal in
                    GoalRow(goal: goal)
                }
            }
            
            Section {
                Button(action: {}) {
                    Label("Add New Goal", systemImage: "plus.circle.fill")
                }
            }
        }
        .navigationTitle("Goals")
    }
}

struct GoalRow: View {
    let goal: AppGoal
    
    var progress: Double {
        min(goal.current / goal.target, 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: goal.icon)
                    .foregroundColor(goal.color)
                    .frame(width: 30)
                
                VStack(alignment: .leading) {
                    Text(goal.title)
                        .font(.headline)
                    Text("\(String(format: "%.1f", goal.current)) / \(String(format: "%.0f", goal.target)) \(goal.unit)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(goal.color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(goal.color)
                        .frame(width: geometry.size.width * progress, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
        .padding(.vertical, 8)
    }
}

struct AchievementsView: View {
    let achievements: [AppAchievement] = [
        AppAchievement(id: "1", title: "First Run", description: "Complete your first run", icon: "figure.run", isUnlocked: true, color: .blue),
        AppAchievement(id: "2", title: "5K Club", description: "Run 5 kilometers", icon: "5.circle.fill", isUnlocked: true, color: .green),
        AppAchievement(id: "3", title: "10K Master", description: "Run 10 kilometers", icon: "10.circle.fill", isUnlocked: false, color: .orange),
        AppAchievement(id: "4", title: "Marathoner", description: "Run a marathon", icon: "figure.run.circle.fill", isUnlocked: false, color: .purple),
        AppAchievement(id: "5", title: "Early Bird", description: "Run before 7 AM", icon: "sunrise.fill", isUnlocked: true, color: .yellow),
        AppAchievement(id: "6", title: "Night Owl", description: "Run after 9 PM", icon: "moon.fill", isUnlocked: false, color: .indigo)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(achievements) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
            .padding()
        }
        .navigationTitle("Achievements")
    }
}

struct AchievementCard: View {
    let achievement: AppAchievement
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? achievement.color.opacity(0.2) : Color.gray.opacity(0.2))
                    .frame(width: 70, height: 70)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 30))
                    .foregroundColor(achievement.isUnlocked ? achievement.color : .gray)
            }
            
            Text(achievement.title)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(achievement.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            if achievement.isUnlocked {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
                    .font(.title3)
            } else {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
    }
}

struct SettingsView: View {
    @State private var useMetric = true
    @State private var notificationsEnabled = true
    @State private var autoPause = true
    
    var body: some View {
        List {
            Section(header: Text("Units")) {
                Toggle("Use Metric System", isOn: $useMetric)
            }
            
            Section(header: Text("Recording")) {
                Toggle("Auto-pause", isOn: $autoPause)
                Toggle("Audio Cues", isOn: .constant(true))
            }
            
            Section(header: Text("Notifications")) {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                NavigationLink("Goal Reminders") {
                    Text("Goal Reminders Settings")
                        .navigationTitle("Goal Reminders")
                }
            }
            
            Section(header: Text("About")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                NavigationLink("Privacy Policy") {
                    Text("Privacy Policy Content")
                        .navigationTitle("Privacy Policy")
                }
                
                NavigationLink("Terms of Service") {
                    Text("Terms of Service Content")
                        .navigationTitle("Terms of Service")
                }
            }
        }
        .navigationTitle("Settings")
    }
}
