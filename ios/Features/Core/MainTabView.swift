import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                ActivitiesListView()
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Activities")
            }
            .tag(0)
            
            NavigationView {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(1)
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}
