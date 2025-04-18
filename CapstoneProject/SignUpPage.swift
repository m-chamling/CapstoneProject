import SwiftUI

struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            // Back Button with arrow and text
            HStack {
                Button(action: {
                    // Action for back button
                }) {
                    HStack {
                        Image(systemName: "arrow.left.circle.fill")  // Use your custom image if needed
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)  // Adjust the size of the arrow
                            .foregroundColor(.blue)  // Set the color of the arrow

                        Text("Back")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.blue)  // Color of the "Back" text
                    }
                }
                Spacer()
            }
            .padding()

            // Logo
            Image("pawLogo")  // Replace with your logo image name
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.top, 50)

            // Title
            Text("PawRescue")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            // Subtitle
            Text("Sign Up")
                .font(.title2)
                .padding(.top, 5)

            // Instructions Text
            Text("Enter your credentials to continue")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 5)

            // Name TextField
            TextField("Name", text: $name)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: .infinity, minHeight: 60)
                .cornerRadius(30)
                .padding(.top, 30)

            // Email TextField
            TextField("Email", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .frame(maxWidth: .infinity, minHeight: 60)
                .cornerRadius(30)
                .padding(.top, 20)

            // Password SecureField
            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: .infinity, minHeight: 60)
                .cornerRadius(30)
                .padding(.top, 20)

            // Sign Up Button
            Button(action: {
                // Sign Up action
            }) {
                Text("Sign Up")
                    .font(.custom("Helvetica-Bold", size: 19))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color(hex: "#312F30"))
                    .cornerRadius(30)
                    .padding(.top, 30)
                    .multilineTextAlignment(.center)
            }

            // Already have an account Login Link
            HStack {
                Text("Already have an account?")
                Button("Login") {
                    // Action to navigate to the Login screen
                }
                .foregroundColor(.blue)
            }
            .padding(.top, 20)

            Spacer()

            // Animal Images at the bottom
            HStack {
                Image("animals")  // Replace with your animal image asset
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)  // Adjust height as necessary
            }
            .padding(.top, 40)
        }
        .padding()
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

