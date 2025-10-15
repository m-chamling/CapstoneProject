import Foundation

enum CodableStore {
    static func decodeArray<T: Decodable>(_ data: Data) -> [T] {
        (try? JSONDecoder().decode([T].self, from: data)) ?? []
    }

    static func encodeArray<T: Encodable>(_ array: [T]) -> Data {
        (try? JSONEncoder().encode(array)) ?? Data()
    }
}
