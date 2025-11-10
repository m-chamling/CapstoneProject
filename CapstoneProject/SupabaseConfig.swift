import Foundation

enum Supa {
    static let (url, anon) = load()

    private static func load() -> (URL, String) {
        guard
            let plistURL = Bundle.main.url(forResource: "Supabase", withExtension: "plist"),
            let dict = NSDictionary(contentsOf: plistURL) as? [String: Any],
            var urlStr = dict["SUPABASE_URL"] as? String,
            var key = dict["SUPABASE_ANON_KEY"] as? String
        else {
            fatalError("❌ Missing Supabase.plist or required keys.")
        }

        // Trim any invisible spaces/newlines
        urlStr = urlStr.trimmingCharacters(in: .whitespacesAndNewlines)
        key = key.trimmingCharacters(in: .whitespacesAndNewlines)

        // Accept short refs like "abcd123efg456" or full URLs
        let fullURL: URL
        if urlStr.hasPrefix("http") {
            guard let u = URL(string: urlStr) else {
                fatalError("❌ Invalid SUPABASE_URL format: \(urlStr)")
            }
            fullURL = u
        } else {
            guard let u = URL(string: "https://\(urlStr).supabase.co") else {
                fatalError("❌ Invalid Supabase project ref: \(urlStr)")
            }
            fullURL = u
        }

        return (fullURL, key)
    }
}
