import Foundation

@MainActor
final class ReportsStore: ObservableObject {
    @Published var reports: [RescueReport] = [] {
        didSet { saveReports() }
    }

    private let key = "saved_reports_v1"

    init() {
        loadReports()
    }

    // MARK: - Add / Remove / Clear

    func add(_ report: RescueReport) {
        reports.append(report)
    }

    func remove(_ report: RescueReport) {
        reports.removeAll { $0.id == report.id }
    }

    func clearAll() {
        reports.removeAll()
    }

    // MARK: - Persistence (UserDefaults)

    private func saveReports() {
        do {
            let data = try JSONEncoder().encode(reports)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("❌ Failed to save reports:", error)
        }
    }

    private func loadReports() {
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        do {
            reports = try JSONDecoder().decode([RescueReport].self, from: data)
        } catch {
            print("❌ Failed to load saved reports:", error)
            reports = []
        }
    }
}
