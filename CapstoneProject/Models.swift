import SwiftData
import Foundation

@Model
final class UserEntity {
    @Attribute(.unique) var email: String
    var id: UUID
    var name: String
    var passwordHash: String

    init(id: UUID = UUID(), name: String, email: String, passwordHash: String) {
        self.id = id
        self.name = name
        self.email = email.lowercased()
        self.passwordHash = passwordHash
    }
}

@Model
final class ReportEntity {
    var id: UUID
    var createdAt: Date
    var animalType: String
    var color: String
    var incidentDate: Date
    var status: String     // store as string (e.g., AnimalStatus.rawValue)
    var nearestLandmark: String
    var descText: String
    var latitude: Double?
    var longitude: Double?

    init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        animalType: String = "",
        color: String = "",
        incidentDate: Date = .now,
        status: String = "Unknown",
        nearestLandmark: String = "",
        descText: String = "",
        latitude: Double? = nil,
        longitude: Double? = nil
    ) {
        self.id = id
        self.createdAt = createdAt
        self.animalType = animalType
        self.color = color
        self.incidentDate = incidentDate
        self.status = status
        self.nearestLandmark = nearestLandmark
        self.descText = descText
        self.latitude = latitude
        self.longitude = longitude
    }
}
