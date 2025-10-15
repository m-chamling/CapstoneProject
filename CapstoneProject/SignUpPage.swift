import SwiftUI
import SwiftData

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?

    private enum Field { case name, email, password }

    private var canSubmit: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
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

            // Subtitle
            Text("Sign Up")
                .font(.custom("Helvetica-Bold", size: 27))
                .padding(.top, 100)
                .foregroundColor(Color(hex: "#312F30"))

            Text("Enter your credentials to continue")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 0.5)

            // Name
            TextField("Name", text: $name)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled(false)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 50)
                .cornerRadius(30)
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .onSubmit { focusedField = .email }

            // Email
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 50)
                .cornerRadius(30)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }

            // Password
            SecureField("Password", text: $password)
                .textContentType(.newPassword)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 50)
                .cornerRadius(30)
                .focused($focusedField, equals: .password)
                .submitLabel(.go)
                .onSubmit { attemptSignUp() }

            // Sign Up Button
            Button(action: attemptSignUp) {
                Text("Sign Up")
                    .font(.custom("Helvetica-Bold", size: 19))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(canSubmit ? Color(hex: "#312F30") : Color.gray.opacity(0.5))
                    .cornerRadius(30)
                    .padding(.horizontal, 30)
            }
            .disabled(!canSubmit)

            // Already have an account?
            HStack {
                Text("Already have an account?")
                    .font(.body)
                    .foregroundColor(.gray)
                NavigationLink("Login") {
                    LoginView()
                }
                .font(.custom("Helvetica-Bold", size: 16))
                .foregroundColor(Color(hex: "#9FAEAB"))
            }
            .padding(.top, 20)

            Spacer()

            // Animal Images at the bottom
            HStack {
                Image("animals")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .alert("Sign Up Failed",
               isPresented: .constant(auth.authError != nil),
               presenting: auth.authError) { _ in
            Button("OK", role: .cancel) { auth.authError = nil }
        } message: { errorMessage in
            Text(errorMessage)
        }
        .onAppear { focusedField = .name }
    }

    private func attemptSignUp() {
        auth.signup(name: name, email: email, password: password, modelContext: modelContext)
        // On success, RootGateView will switch to MainAppView automatically.
    }
}

#Preview("Sign Up") {
    // In-memory SwiftData for previews (no on-disk DB)
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: UserEntity.self, configurations: config)

    return NavigationStack {
        SignUpView()
            .environmentObject(AuthViewModel())
            .modelContainer(container)
    }
}
