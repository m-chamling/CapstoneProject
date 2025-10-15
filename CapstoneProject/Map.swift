import SwiftUI
import MapKit
import CoreLocation

struct RescueMapScreen: View {
    // Start near Northfield; you can swap to .userLocation if you want
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.151, longitude: -72.658),
            span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        )
    )

    var body: some View {
        NavigationStack {
            ZStack {
                // MAP
                Map(position: $position) {
                    UserAnnotation()
                    // demo pin
                    Marker("Northfield", coordinate: CLLocationCoordinate2D(latitude: 44.153, longitude: -72.666)).tint(.red)
                }
                .ignoresSafeArea()

                // OVERLAYS
                VStack {
                    // Top row: Profile (top-right)
                    HStack {
                        Spacer()
                        NavigationLink { UserProfileView() } label: {
                            Image("Profile")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height:60)
                        }
                        .padding(.trailing, 2)
                        .padding(.top, 20)
                    }

                    Spacer()

                    // Bottom row
                    ZStack {
                        // Bottom dock background (like your screenshot)
                        Rectangle()
                            .fill(Color.black.opacity(0.85))
                            .frame(height: 65)
                            .ignoresSafeArea(edges: .bottom)

                        // Paw button (center) -> View Reports
                        NavigationLink { ViewReportsView() } label: {
                            VStack(spacing: 4) {
                                Image(systemName: "pawprint.circle.fill")
                                    .font(.system(size: 32, weight: .bold))
                                Image(systemName: "heart") // tiny heart like your mock
                                    .font(.system(size: 12, weight: .semibold))
                            }
                            .foregroundStyle(.white)
                        }
                    }
                    .overlay(
                        
                        // Bottom-right: Create Report warning button
                        HStack {
                            Spacer()
                            Button(action: {
                                // Action for back button
                            }) {
                                Image("report")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height:80)
                            }
                            .padding(.bottom, 125)
                        }
                    )
                }
            }
            .mapControls {
                MapCompass()
                MapUserLocationButton()
            }
            .task {
                // ask for permission so UserAnnotation shows
                await LocationAuthorizer.requestWhenInUse()
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Tiny helpers
struct CircleIcon: View {
    let systemName: String
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 22, weight: .semibold))
            .frame(width: 44, height: 44)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
            .shadow(radius: 3, y: 1)
            .foregroundStyle(.primary)
    }
}

enum LocationAuthorizer {
    static func requestWhenInUse() async {
        let m = CLLocationManager()
        if m.authorizationStatus == .notDetermined {
            m.requestWhenInUseAuthorization()
        }
    }
}

// MARK: - Destination stubs (replace with your real screens)
struct ProfileView: View { var body: some View { Text("Profile").font(.title) } }
struct CreateReportView: View { var body: some View { Text("Create Report").font(.title) } }
struct ViewReportsView: View { var body: some View { Text("Reports").font(.title) } }

// MARK: - Preview
#Preview { RescueMapScreen() }
