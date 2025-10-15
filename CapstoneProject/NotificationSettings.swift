import Foundation
import CoreLocation

struct NotificationPrefs: Codable {
    var enabled: Bool = false
    var radiusMiles: Double = 10
    var centerLat: Double? = nil
    var centerLon: Double? = nil
}

enum Distance {
    static func miles(_ a: CLLocationCoordinate2D, _ b: CLLocationCoordinate2D) -> Double {
        let la = CLLocation(latitude: a.latitude, longitude: a.longitude)
        let lb = CLLocation(latitude: b.latitude, longitude: b.longitude)
        return la.distance(from: lb) / 1609.344
    }
}

@MainActor
final class NotificationSettings: ObservableObject {
    @Published private(set) var prefs = NotificationPrefs()
    private let keyBase = "notif_prefs_"       // will append user email (lowercased)

    func load(forEmail email: String) {
        let key = keyBase + email.lowercased()
        if let data = UserDefaults.standard.data(forKey: key),
           let saved = try? JSONDecoder().decode(NotificationPrefs.self, from: data) {
            prefs = saved
        } else {
            prefs = NotificationPrefs()
        }
    }

    func save(forEmail email: String) {
        let key = keyBase + email.lowercased()
        if let data = try? JSONEncoder().encode(prefs) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func setEnabled(_ on: Bool, forEmail email: String) {
        prefs.enabled = on
        save(forEmail: email)
    }

    func setRadius(_ miles: Double, forEmail email: String) {
        prefs.radiusMiles = min(max(miles, 0), 50)
        save(forEmail: email)
    }

    func setCenter(_ coord: CLLocationCoordinate2D?, forEmail email: String) {
        prefs.centerLat = coord?.latitude
        prefs.centerLon = coord?.longitude
        save(forEmail: email)
    }

    var centerCoordinate: CLLocationCoordinate2D? {
        guard let lat = prefs.centerLat, let lon = prefs.centerLon else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
