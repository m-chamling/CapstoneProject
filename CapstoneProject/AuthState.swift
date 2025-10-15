import SwiftUI
import SwiftData
import CryptoKit

// MARK: - Session state
enum AuthState: Equatable {
    case loggedOut
    case guest
    case loggedIn(AppUser)
}

// MARK: - ViewModel
@MainActor
final class AuthViewModel: ObservableObject {
    @Published var state: AuthState = .loggedOut
    @Published var authError: String? = nil

    @AppStorage("savedEmail") private var savedEmail = ""
    @AppStorage("isGuest") private var isGuest = false

    init() {
        // Restore simple session
        if isGuest {
            state = .guest
        } else if !savedEmail.isEmpty {
            state = .loggedIn(
                AppUser(
                    id: UUID(),
                    username: savedEmail.split(separator: "@").first.map(String.init) ?? "User",
                    email: savedEmail
                )
            )
        } else {
            state = .loggedOut
        }
    }

    // MARK: - Signup (SwiftData)
    func signup(name: String, email: String, password: String, modelContext: ModelContext) {
        authError = nil

        let n = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let e = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !n.isEmpty, !e.isEmpty, !password.isEmpty else {
            authError = "Please fill all fields."
            return
        }
        guard isValidEmail(e) else {
            authError = "Please enter a valid email."
            return
        }

        let svc = AuthService(context: modelContext)
        if svc.findUser(byEmail: e) != nil {
            authError = "An account with this email already exists."
            return
        }

        let hash = AuthPasswordHashing.sha256(password)
        do {
            let user = try svc.createUser(name: n, email: e, passwordHash: hash)
            savedEmail = user.email
            isGuest = false
            state = .loggedIn(AppUser(id: user.id, username: user.name, email: user.email))
        } catch {
            authError = "Could not create account. Try again."
        }
    }

    // MARK: - Login (SwiftData)
    func login(email: String, password: String, modelContext: ModelContext) {
        authError = nil

        let e = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !e.isEmpty, !password.isEmpty else {
            authError = "Please enter email and password."
            return
        }

        let svc = AuthService(context: modelContext)
        guard let u = svc.findUser(byEmail: e) else {
            authError = "No account found for this email."
            return
        }

        if u.passwordHash != AuthPasswordHashing.sha256(password) {
            authError = "User credentials did not match."
            return
        }

        savedEmail = u.email
        isGuest = false
        state = .loggedIn(AppUser(id: u.id, username: u.name, email: u.email))
    }

    func continueAsGuest() {
        isGuest = true
        state = .guest
    }

    func logout() {
        savedEmail = ""
        isGuest = false
        state = .loggedOut
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}

// MARK: - Password hashing helper
enum AuthPasswordHashing {
    static func sha256(_ text: String) -> String {
        let digest = SHA256.hash(data: Data(text.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
