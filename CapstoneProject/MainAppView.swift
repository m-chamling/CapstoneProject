import SwiftUI

struct MainAppView: View {
    var body: some View {
        TabView {
            // MAP TAB
            RescueMapScreen()
                .tabItem { Label("Map", systemImage: "map") }

            // REPORTS TAB
            ExploreReportsView()
                .tabItem { Label("Reports", systemImage: "list.bullet") }
            
            // CREATE TAB
            CreateReportFlow()
                .tabItem { Label("Create", systemImage: "plus") }

            // PROFILE TAB
            UserProfileView()
                .tabItem { Label("Profile", systemImage: "person.circle") }
        }
    }
}

#Preview {
    MainAppView()
}
