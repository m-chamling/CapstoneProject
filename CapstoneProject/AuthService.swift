import Foundation
import SwiftData

@MainActor
struct AuthService {
    let context: ModelContext

    func findUser(byEmail email: String) -> UserEntity? {
        let e = email.lowercased()
        let descriptor = FetchDescriptor<UserEntity>(predicate: #Predicate { user in
            user.email == e
        })
        return (try? context.fetch(descriptor))?.first
    }

    func createUser(name: String, email: String, passwordHash: String) throws -> UserEntity {
        let u = UserEntity(name: name, email: email.lowercased(), passwordHash: passwordHash)
        context.insert(u)
        try context.save()
        return u
    }
}

