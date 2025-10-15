import SwiftUI

@main
struct CapstoneProjectApp: App {
    @StateObject private var auth = AuthViewModel()
    @StateObject private var store = ReportsStore()
    @StateObject private var notif = NotificationSettings()

    var body: some Scene {
        WindowGroup {
            RootGateView()
                .environmentObject(auth)
                .environmentObject(store)
                .environmentObject(notif)
                .task {
                    _ = await NotificationManager.shared.requestAuthorization()
                }
        }
    }
}
