import Foundation

enum Supa {
    static let (url, anon) = load()

    private static func load() -> (URL, String) {
        guard
            let url = Bundle.main.url(forResource: "Supabase", withExtension: "plist"),
            let dict = NSDictionary(contentsOf: url) as? [String: Any],
            let urlStr = dict["SUPABASE_URL"] as? String,
            let key = dict["SUPABASE_ANON_KEY"] as? String,
            let base = URL(string: urlStr)
        else {
            fatalError("❌ Missing Supabase.plist or keys.")
        }
        return (base, key)
    }
}
