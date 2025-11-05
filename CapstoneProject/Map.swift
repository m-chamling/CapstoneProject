import SwiftUI
import MapKit
import CoreLocation

struct RescueMapScreen: View {
    // Start near Northfield; change to .userLocation if you want later
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.151, longitude: -72.658),
            span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        )
    )

    var body: some View {
        Map(position: $position) {
           
            UserAnnotation()
        }
        .ignoresSafeArea()
        .mapControls {
            MapCompass()
            MapUserLocationButton()
        }
        .task {
            await LocationAuthorizer.requestWhenInUse()
        }
    }
}

// MARK: - Tiny helper
enum LocationAuthorizer {
    static func requestWhenInUse() async {
        let m = CLLocationManager()
        if m.authorizationStatus == .notDetermined {
            m.requestWhenInUseAuthorization()
        }
    }
}

// MARK: - Preview
#Preview {
    RescueMapScreen()
}
