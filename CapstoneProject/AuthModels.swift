import Foundation

struct AppUser: Identifiable, Codable, Equatable {
    let id: UUID
    var username: String
    var email: String
}

struct StoredUser: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var email: String
    var passwordHash: String   // SHA256 of the password (not the raw password)
}
