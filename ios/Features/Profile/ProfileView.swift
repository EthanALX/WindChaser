import SwiftUI

struct ProfileView: View {
    @State private var user = User.current
    @State private var stats = UserStats.empty
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ProfileHeader(user: user)
                StatsGrid(stats: stats)
                GoalsSection()
                AchievementsSection()
            }
            .padding()
        }
        .navigationTitle("Profile")
    }
}

struct ProfileHeader: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text(user.displayName)
                .font(.title)
                .fontWeight(.bold)
            
            Text(user.email)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
    }
}

struct StatsGrid: View {
    let stats: UserStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Statistics")
                .font(.title2)
                .fontWeight(.bold)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ProfileStatBox(title: "Total Distance", value: String(format: "%.0f km", stats.totalDistance), icon: "ruler")
                ProfileStatBox(title: "Activities", value: "\(stats.totalRuns)", icon: "figure.run")
                ProfileStatBox(title: "Active Days", value: "\(stats.activeDays)", icon: "calendar")
                ProfileStatBox(title: "Marathons", value: "\(stats.totalMarathons)", icon: "trophy")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
    }
}

struct ProfileStatBox: View {
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

struct GoalsSection: View {
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

struct AchievementsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Achievements")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Start running to earn achievements!")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
    }
}

#Preview {
    NavigationView {
        ProfileView()
    }
}
