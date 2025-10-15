import SwiftUI
import CoreLocation

struct ManageNotificationsView: View {
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var notif: NotificationSettings
    @State private var tempRadius: Double = 10
    @State private var isEnabled: Bool = false
    @State private var hasLoaded = false

    var body: some View {
        let email = currentEmail

        Form {
            Section(header: Text("Alerts")) {
                Toggle("Enable notifications", isOn: Binding(
                    get: { isEnabled },
                    set: { newVal in
                        isEnabled = newVal
                        if let e = email { notif.setEnabled(newVal, forEmail: e) }
                    }
                ))
            }

            Section(header: Text("Distance Radius")) {
                VStack(alignment: .leading, spacing: 8) {
                    Slider(value: $tempRadius, in: 0...50, step: 1) { Text("Radius") }
                    Text("\(Int(tempRadius)) miles").font(.callout).foregroundStyle(.secondary)
                }
                .onChange(of: tempRadius) {
                    if let e = email { notif.setRadius(tempRadius, forEmail: e) }
                }
            }

            Section(header: Text("Center Point")) {
                Text(centerSummary)
                Button("Use My Current Location") {
                    Task { await captureCurrentLocationAndSave() }
                }
            }
        }
        .navigationTitle("Manage Notification")
        .onAppear {
            guard !hasLoaded else { return }
            hasLoaded = true
            if let e = email {
                notif.load(forEmail: e)
                isEnabled = notif.prefs.enabled
                tempRadius = notif.prefs.radiusMiles
            }
        }
    }

    private var currentEmail: String? {
        if case let .loggedIn(u) = auth.state { return u.email }
        return nil
    }

    private var centerSummary: String {
        if let c = notif.centerCoordinate {
            return String(format: "Center at %.4f, %.4f", c.latitude, c.longitude)
        } else {
            return "No center set. Pick your current location."
        }
    }

    private func captureCurrentLocationAndSave() async {
        let mgr = CLLocationManager()
        if mgr.authorizationStatus == .notDetermined {
            mgr.requestWhenInUseAuthorization()
            try? await Task.sleep(nanoseconds: 400_000_000)
        }
        if mgr.authorizationStatus == .denied { return }
        mgr.startUpdatingLocation()
        try? await Task.sleep(nanoseconds: 600_000_000)
        mgr.stopUpdatingLocation()
        if let coord = mgr.location?.coordinate, let e = currentEmail {
            notif.setCenter(coord, forEmail: e)
        }
    }
}

