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

            // PROFILE TAB
            UserProfileView()
                .tabItem { Label("Profile", systemImage: "person.circle") }
        }
    }
}

#Preview {
    MainAppView()
}
