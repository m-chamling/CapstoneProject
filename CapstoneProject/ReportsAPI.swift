import Foundation

enum ReportsAPI {
    // REST endpoint: /rest/v1/public_reports
    private static var base: URL { Supa.url.appendingPathComponent("rest/v1/public_reports") }
    private static var key: String { Supa.anon }

    // Network DTO (no media upload yet)
    struct NetReport: Codable, Identifiable {
        let id: UUID
        let created_at: Date?
        var animalType: String?
        var color: String?
        var incidentDate: Date?
        var status: String?
        var nearestLandmark: String?
        var description: String?
        var category: String?
        var latitude: Double?
        var longitude: Double?
    }

    // MARK: - Create (POST)
    static func create(from r: RescueReport, category: ReportCategory) async throws {
        let dto = NetReport(
            id: r.id,
            created_at: r.createdAt,
            animalType: r.animalType,
            color: r.color,
            incidentDate: r.incidentDate,
            status: r.status.rawValue,
            nearestLandmark: r.nearestLandmark,
            description: r.description,
            category: category.rawValue,
            latitude: r.latitude,
            longitude: r.longitude
        )

        var req = URLRequest(url: base)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        req.setValue(key, forHTTPHeaderField: "apikey")
        req.httpBody = try JSONEncoder.iso8601.encode([dto]) // Supabase accepts arrays

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw APIError.badStatus((resp as? HTTPURLResponse)?.statusCode ?? -1,
                                     String(data: data, encoding: .utf8))
        }
    }

    // MARK: - Fetch (GET)
    static func fetch(category: ReportCategory?) async throws -> [NetReport] {
        var comps = URLComponents(url: base, resolvingAgainstBaseURL: false)!
        var items = [
            URLQueryItem(name: "select", value: "*"),
            URLQueryItem(name: "order", value: "created_at.desc")
        ]
        if let c = category {
            items.append(URLQueryItem(name: "category", value: "eq.\(c.rawValue)"))
        }
        comps.queryItems = items

        var req = URLRequest(url: comps.url!)
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        req.setValue(key, forHTTPHeaderField: "apikey")

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw APIError.badStatus((resp as? HTTPURLResponse)?.statusCode ?? -1,
                                     String(data: data, encoding: .utf8))
        }
        return try JSONDecoder.iso8601.decode([NetReport].self, from: data)
    }

    
    // MARK: - Update status (PATCH)
    static func updateStatus(id: UUID, status: String) async throws {
        var comps = URLComponents(url: base, resolvingAgainstBaseURL: false)!
        comps.queryItems = [URLQueryItem(name: "id", value: "eq.\(id.uuidString)")]

        var req = URLRequest(url: comps.url!)
        req.httpMethod = "PATCH"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        req.setValue(key, forHTTPHeaderField: "apikey")
        req.httpBody = try JSONEncoder.iso8601.encode(["status": status])

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw APIError.badStatus((resp as? HTTPURLResponse)?.statusCode ?? -1,
                                     String(data: data, encoding: .utf8))
        }
    }

    enum APIError: Error {
        case badStatus(Int, String?)
    }
}

extension JSONEncoder {
    static var iso8601: JSONEncoder {
        let e = JSONEncoder(); e.dateEncodingStrategy = .iso8601; return e
    }
}
extension JSONDecoder {
    static var iso8601: JSONDecoder {
        let d = JSONDecoder(); d.dateDecodingStrategy = .iso8601; return d
    }
}

// MARK: - Debug connectivity test
extension ReportsAPI {
    static func debugPing() async {
        guard let url = URL(string: "\(Supa.url.absoluteString)/rest/v1/public_reports?select=id&limit=1") else {
            print("🚫 Bad URL"); return
        }
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("Bearer \(Supa.anon)", forHTTPHeaderField: "Authorization")
        req.setValue(Supa.anon, forHTTPHeaderField: "apikey")

        do {
            let (data, resp) = try await URLSession.shared.data(for: req)
            if let http = resp as? HTTPURLResponse {
                print("🌍 HTTP", http.statusCode)
            }
            print("📦 Body:", String(data: data, encoding: .utf8) ?? "<non-utf8>")
        } catch {
            print("❌ ERROR:", error.localizedDescription)
        }
    }
}

