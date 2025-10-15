import Foundation

public struct AppUser: Identifiable, Codable, Equatable {
    public let id: UUID
    public var username: String
    public var email: String

    public init(id: UUID, username: String, email: String) {
        self.id = id
        self.username = username
        self.email = email
    }
}
