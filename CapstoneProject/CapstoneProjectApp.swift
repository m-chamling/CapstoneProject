import SwiftUI
import SwiftData

@main
struct CapstoneProjectApp: App {
    @StateObject private var auth = AuthViewModel()
    @StateObject private var notif = NotificationSettings()

    var body: some Scene {
        WindowGroup {
            RootGateView()
                .environmentObject(auth)
                .environmentObject(notif)
                .task { _ = await NotificationManager.shared.requestAuthorization() }
        }
        // 👇 this gives your whole app a Core Data / SwiftData store
        .modelContainer(for: [UserEntity.self, ReportEntity.self])
    }
}


