import SwiftUI
import MapKit
import CoreLocation

struct RescueMapScreen: View {
    // Start centered near Northfield; you can change later or auto-center to user
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.151, longitude: -72.658),
            span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        )
    )

    // Supabase-loaded reports
    @State private var items: [ReportsAPI.NetReport] = []
    @State private var isLoading = false
    @State private var errorText: String?

    // For showing the detail sheet when a pin is tapped
    @State private var selected: ReportsAPI.NetReport?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $position) {
                // User dot
                UserAnnotation()

                // Report pins
                ForEach(itemsWithCoordinates, id: \.id) { r in
                    if let coord = coordinate(of: r) {
                        // A simple map marker with a tap
                        Annotation("", coordinate: coord) {
                            Image(systemName: "pawprint.fill")
                                .font(.title2)
                                .padding(6)
                                .background(Circle().fill(.ultraThinMaterial))
                                .onTapGesture { selected = r }
                                .accessibilityLabel(r.animalType ?? "Animal")
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .mapControls {
                MapCompass()
                MapUserLocationButton()
                MapScaleView()
            }
            .task {
                await LocationAuthorizer.requestWhenInUse()
                await loadAll()
            }
            .refreshable { await loadAll() }
            .sheet(item: $selected) { report in
                // Uses the Supabase-backed detail to allow status updates
                ReportDetailViewNet(report: report)
            }

            // Small toolbar for reload + recenter
            HStack(spacing: 8) {
                Button {
                    Task { await loadAll() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .padding(10)
                }
                .background(.thinMaterial)
                .clipShape(Circle())

                Button {
                    recenterToFirstReport()
                } label: {
                    Image(systemName: "scope")
                        .padding(10)
                }
                .background(.thinMaterial)
                .clipShape(Circle())
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
            if isLoading {
                ProgressView("Loading reports…")
                    .padding(12)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .padding(.bottom, 20)
            } else if let errorText {
                VStack(spacing: 8) {
                    Text("Failed to load").bold()
                    Text(errorText).font(.caption).foregroundStyle(.secondary)
                    Button("Retry") { Task { await loadAll() } }
                        .buttonStyle(.borderedProminent)
                }
                .padding(12)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .padding(.bottom, 20)
            }
        }
    }

    // MARK: - Helpers

    private var itemsWithCoordinates: [ReportsAPI.NetReport] {
        items.filter { $0.latitude != nil && $0.longitude != nil }
    }

    private func coordinate(of r: ReportsAPI.NetReport) -> CLLocationCoordinate2D? {
        guard let lat = r.latitude, let lon = r.longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    private func loadAll() async {
        isLoading = true
        errorText = nil
        do {
            // nil category → fetch ALL categories for the map
            items = try await ReportsAPI.fetch(category: nil)
        } catch {
            items = []
            errorText = "\(error)"
        }
        isLoading = false
    }

    private func recenterToFirstReport() {
        guard let first = itemsWithCoordinates.first, let coord = coordinate(of: first) else { return }
        let region = MKCoordinateRegion(center: coord,
                                        span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15))
        position = .region(region)
    }
}

// Tiny helper you already had; keeping it here for completeness
enum LocationAuthorizer {
    static func requestWhenInUse() async {
        let m = CLLocationManager()
        if m.authorizationStatus == .notDetermined {
            m.requestWhenInUseAuthorization()
        }
    }
}

#Preview {
    RescueMapScreen()
}
