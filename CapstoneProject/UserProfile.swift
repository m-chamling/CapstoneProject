import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    private var displayName: String {
        switch auth.state {
        case .loggedIn(let user):
            return user.username.isEmpty ? "Profile" : user.username
        case .guest:
            return "Guest"
        case .loggedOut:
            return "Profile"
        }
    }

    private var emailText: String {
        if case let .loggedIn(u) = auth.state { return u.email }
        return "Signed in as Guest"
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Back Button
                    HStack {
                        Button(action: { dismiss() }) {
                            Image("Arrow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            Text("Back")
                                .font(.body)
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding(.top, -20)
                    .padding(.bottom, 30)
                    .padding(.horizontal, 23)

                    // Logo/Image
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 65, height: 65)
                        .padding(.top, 40)

                    // App Title
                    Text("PawRescue")
                        .font(.custom("Helvetica-Bold", size: 22))
                        .padding(.top, 5)
                        .foregroundColor(Color(hex: "#312F30"))

                    // Avatar
                    Image("avatar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                        .padding(.top, 32)

                    // Dynamic title + subtitle
                    VStack(spacing: 6) {
                        Text(displayName)
                            .font(.custom("Helvetica-Bold", size: 27))
                            .foregroundColor(Color(hex: "#312F30"))
                            .kerning(0.2)
                            .lineSpacing(30)

                        Text(emailText)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 20)

                    // Menu
                    Group {
                        Divider().padding(.horizontal)

                        ProfileRow(title: "Account") {
                            // TODO: navigate to Account screen
                        }
                        Divider().padding(.horizontal)

                        ProfileRow(title: "Rewards") {
                            // TODO: navigate to Rewards screen
                        }
                        Divider().padding(.horizontal)

                        // Only logged-in users can manage notifications
                        if case .loggedIn = auth.state {
                            NavigationLink(destination: ManageNotificationsView()) {
                                Text("Manage Notification")
                                    .font(.custom("Helvetica-Bold", size: 18))
                                    .foregroundColor(.gray)
                                    .kerning(0.2)
                                    .lineSpacing(30)
                                    .frame(maxWidth: .infinity, minHeight: 60)
                            }
                            Divider().padding(.horizontal)
                        }

                        ProfileRow(title: "Feedback") {
                            // TODO: navigate to Feedback screen
                        }
                        Divider().padding(.horizontal)

                        // Log out (for both logged-in and guest)
                        ProfileRow(title: "Log out") {
                            auth.logout()
                        }
                        Divider().padding(.horizontal)
                    }
                    .background(Color(.systemBackground))
                    .edgesIgnoringSafeArea(.all)
                }
            }
        }
        // If you show this inside a NavigationStack, you can mirror the title:
        // .navigationTitle(displayName)
        // .navigationBarTitleDisplayMode(.inline)
    }
}

// A full-width centered row
private struct ProfileRow: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Helvetica-Bold", size: 18))
                .foregroundColor(.gray)
                .kerning(0.2)
                .lineSpacing(30)
                .frame(maxWidth: .infinity, minHeight: 60)
        }
        .background(Color(.systemBackground))
    }
}

#Preview("Logged In") {
    let vm = AuthViewModel()
    vm.state = .loggedIn(AppUser(id: UUID(), username: "Mangtoya", email: "you@example.com"))
    return NavigationStack {
        UserProfileView()
            .environmentObject(vm)
            .environmentObject(NotificationSettings()) // needed for ManageNotificationsView
    }
}

#Preview("Guest") {
    let vm = AuthViewModel()
    vm.continueAsGuest()
    return NavigationStack {
        UserProfileView()
            .environmentObject(vm)
            .environmentObject(NotificationSettings())
    }
}
