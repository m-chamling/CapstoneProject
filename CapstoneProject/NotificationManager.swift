
import Foundation
import UserNotifications
import CoreLocation

@MainActor
final class NotificationManager {
    static let shared = NotificationManager()

    func requestAuthorization() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let granted = try? await center.requestAuthorization(options: [.alert, .badge, .sound])
        return granted ?? false
    }

    func scheduleReportNearby(_ report: RescueReport, milesAway: Double) {
        let content = UNMutableNotificationContent()
        content.title = "New report nearby"
        let animal = report.animalType.isEmpty ? "Animal" : report.animalType
        let whereStr = report.nearestLandmark.isEmpty ? "" : " near \(report.nearestLandmark)"
        content.body = "\(animal) reported\(whereStr) • \(String(format: "%.1f", milesAway)) mi away"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(req)
    }

    /// call when a new report is created
    func notifyIfWithinRadius(report: RescueReport, settings: NotificationSettings) {
        guard settings.prefs.enabled,
              let userCenter = settings.centerCoordinate,
              let lat = report.latitude, let lon = report.longitude else { return }

        let rCoord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let d = Distance.miles(userCenter, rCoord)
        if d <= settings.prefs.radiusMiles {
            scheduleReportNearby(report, milesAway: d)
        }
    }
}
