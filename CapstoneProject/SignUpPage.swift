import SwiftUI

struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            // Back Button
            HStack {
                Button(action: {
                    // Action for back button
                }) {
                    Image("Arrow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height:30)
                        .font(.title)
                        
                    Text("Back")
                        .font(.body)
                        .foregroundColor(.black)

                }
                Spacer()
            }
            .padding()

            // Logo/Image
            Image("logo") // Replace with your logo image asset name
                .resizable()
                .scaledToFit()
                .frame(width: 65, height: 65) // Adjust size as necessary
                .padding(.top, 75)
            
            // App Title
            Text("PawRescue")
                .font(.custom("Helvetica-Bold", size: 22))
                .padding(.top, 5)
                .foregroundColor(Color(hex: "#312F30"))
                .kerning(0.2)
                .lineSpacing(30)
                .padding(.top, 0)

            // Subtitle
            Text("Sign Up")
                .font(.custom("Helvetica-Bold", size: 27))
                .padding(.top, 100)
                .foregroundColor(Color(hex: "#312F30"))
                .kerning(0.2)
                .lineSpacing(30)
                .padding(.top, 0)

            // Instructions Text
            Text("Enter your credentials to continue")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 0.5)

            // Name TextField
            TextField("Name", text: $name)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 50)
                .cornerRadius(30)

            // Email TextField
            TextField("Email", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 50)
                .cornerRadius(30)

            // Password SecureField
            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 50)
                .cornerRadius(30)

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
                    .padding(.horizontal, 30)
            }

            // Already have an account Login Link
            HStack {
                Text("Already have an account?")
                    .font(.body)
                    .foregroundColor(.gray)
                Button("Login") {
                    // Action to navigate to the Login screen
                }
                .font(.custom("Helvetica-Bold", size: 16))
                .foregroundColor(Color(hex: "#9FAEAB"))
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
            
        }
        .padding()
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

