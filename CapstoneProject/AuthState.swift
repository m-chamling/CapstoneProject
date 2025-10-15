import SwiftUI

// MARK: - Public session state shown to the app
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

    // Persisted session bits
    @AppStorage("savedEmail") private var savedEmail = ""
    @AppStorage("isGuest") private var isGuest = false

    // “Database” of accounts (on-device JSON)
    @AppStorage("users_v1") private var usersData: Data = Data()

    private var users: [StoredUser] {
        get { CodableStore.decodeArray(usersData) as [StoredUser] }
        set { usersData = CodableStore.encodeArray(newValue) }
    }

    init() {
        restoreSession()
        seedDemoIfEmpty() // optional: comment out if you don’t want seed data
    }

    // MARK: - Session
    func restoreSession() {
        if isGuest {
            state = .guest
        } else if !savedEmail.isEmpty, let match = users.first(where: { $0.email == savedEmail }) {
            state = .loggedIn(AppUser(id: match.id, username: match.name, email: match.email))
        } else {
            state = .loggedOut
        }
    }

    func logout() {
        authError = nil
        savedEmail = ""
        isGuest = false
        state = .loggedOut
    }

    func continueAsGuest() {
        authError = nil
        isGuest = true
        state = .guest
    }

    // MARK: - Auth (local)
    func signup(name: String, email: String, password: String) {
        authError = nil

        let n = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let e = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let p = password

        guard !n.isEmpty, !e.isEmpty, !p.isEmpty else {
            authError = "Please fill all fields."
            return
        }
        guard isValidEmail(e) else {
            authError = "Please enter a valid email."
            return
        }
        if users.contains(where: { $0.email == e }) {
            authError = "An account with this email already exists."
            return
        }

        var list = users
        let user = StoredUser(
            id: UUID(),
            name: n,
            email: e,
            passwordHash: PasswordHashing.sha256(p)
        )
        list.append(user)
        users = list

        savedEmail = e
        isGuest = false
        state = .loggedIn(AppUser(id: user.id, username: n, email: e))
    }

    func login(email: String, password: String) {
        authError = nil

        let e = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let pHash = PasswordHashing.sha256(password)

        guard !e.isEmpty, !password.isEmpty else {
            authError = "Please enter email and password."
            return
        }
        guard let match = users.first(where: { $0.email == e }) else {
            authError = "No account found for this email."
            return
        }
        guard match.passwordHash == pHash else {
            authError = "User credentials did not match."
            return
        }

        savedEmail = e
        isGuest = false
        state = .loggedIn(AppUser(id: match.id, username: match.name, email: match.email))
    }

    // MARK: - Utilities
    private func isValidEmail(_ email: String) -> Bool {
        // simple check; good enough for now
        email.contains("@") && email.contains(".")
    }

    /// For testing: creates one demo account if DB is empty
    private func seedDemoIfEmpty() {
        guard users.isEmpty else { return }
        users = [
            StoredUser(
                id: UUID(),
                name: "Demo",
                email: "demo@example.com",
                passwordHash: PasswordHashing.sha256("password123")
            )
        ]
    }

    // Admin/Debug helpers
    func resetAllUsers() {
        users = []
    }
    func listAllUsers() -> [StoredUser] { users }
}
