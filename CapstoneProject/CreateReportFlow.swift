import SwiftUI
import CoreLocation

struct CreateReportFlow: View {
    @State private var currentCoord: CLLocationCoordinate2D?

    var body: some View {
        NavigationStack {
            ReportCategoryView()
                .navigationDestination(for: ReportCategory.self) { category in
                    ReportFormView(
                        category: category,
                        coordinate: currentCoord
                    ) { _ in
                        // no manual path mutation—ReportFormView will call dismiss()
                    }
                }
        }
        .task {
            let mgr = CLLocationManager()
            if mgr.authorizationStatus == .notDetermined {
                mgr.requestWhenInUseAuthorization()
            }
            mgr.startUpdatingLocation()
            try? await Task.sleep(nanoseconds: 600_000_000)
            mgr.stopUpdatingLocation()
            currentCoord = mgr.location?.coordinate
        }
    }
}
