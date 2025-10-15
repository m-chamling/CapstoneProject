import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.modelContext) private var modelContext

    @State private var email = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?

    private enum Field { case email, password }

    var canSubmit: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty
    }

    var body: some View {
        VStack {
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
            .padding()

            // Logo/Image
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 65, height: 65)
                .padding(.top, 75)

            // App Title
            Text("PawRescue")
                .font(.custom("Helvetica-Bold", size: 22))
                .padding(.top, 5)
                .foregroundColor(Color(hex: "#312F30"))

            // Main Title
            Text("Login")
                .font(.custom("Helvetica-Bold", size: 27))
                .padding(.top, 100)
                .foregroundColor(Color(hex: "#312F30"))

            // Subtitle
            Text("Enter Your Email and Password")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 0.5)

            // Email
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(.emailAddress)
                .textContentType(.username)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 50)
                .cornerRadius(30)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }

            // Password
            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 50)
                .cornerRadius(30)
                .focused($focusedField, equals: .password)
                .submitLabel(.go)
                .onSubmit {
                    attemptLogin()
                }

            // Login Button
            Button(action: attemptLogin) {
                Text("Log In")
                    .font(.custom("Helvetica-Bold", size: 19))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(canSubmit ? Color(hex: "#312F30") : Color.gray.opacity(0.5))
                    .cornerRadius(30)
                    .padding(.horizontal, 30)
            }
            .disabled(!canSubmit)

            // Sign Up
            HStack {
                Text("Don't have an account?")
                    .font(.body)
                    .foregroundColor(.gray)

                NavigationLink("Sign Up") {
                    SignUpView()   // ← make sure SignUpView uses modelContext in its button
                }
                .font(.custom("Helvetica-Bold", size: 16))
                .foregroundColor(Color(hex: "#9FAEAB"))
            }
            .padding(.top, 5)

            // Forgot Password (stub)
            HStack {
                Button("Forgot Password") {
                    // TODO: push your ChangePasswordView if you want
                }
                .foregroundColor(Color(hex: "#9FAEAB"))
                .font(.headline)
            }
            .padding(.top, 2)

            // Guest
            Button("Continue as Guest") {
                auth.continueAsGuest()
            }
            .foregroundColor(Color(hex: "#9FAEAB"))
            .font(.headline)
            .padding(.top, 20)

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .alert("Login Failed",
               isPresented: .constant(auth.authError != nil),
               presenting: auth.authError) { _ in
            Button("OK", role: .cancel) { auth.authError = nil }
        } message: { errorMessage in
            Text(errorMessage)
        }
        .onAppear { focusedField = .email }
    }

    private func attemptLogin() {
        auth.login(email: email, password: password, modelContext: modelContext)
        // On success, RootGateView will switch to MainAppView automatically.
    }
}

#Preview("Login Page") {
    // In-memory SwiftData container for previews
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserEntity.self, configurations: config)

    return NavigationStack {
        LoginView()
            .environmentObject(AuthViewModel())
            .modelContainer(container)
    }
}
