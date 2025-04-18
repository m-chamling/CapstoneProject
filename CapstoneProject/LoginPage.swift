import SwiftUI

struct LoginView: View {
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
            
            
            // Main Title (Login)
            Text("Login")
                .font(.custom("Helvetica-Bold", size: 27))
                .padding(.top, 100)
                .foregroundColor(Color(hex: "#312F30"))
                .kerning(0.2)
                .lineSpacing(30)
                .padding(.top, 0)
            
            // Description Text
            Text("Enter Your Email and Password")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 0.5)
            
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
            
            
            // Login Button
            Button(action: {
                // Login Action will be here
            }) {
                Text("Log In")
                    .font(.custom("Helvetica-Bold", size: 19))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color(hex: "#312F30"))
                    .cornerRadius(30)
                    .padding(.horizontal, 30)
            }
            
            // Don't have an account Option
            HStack {
                Text("Don't have an account?")
                    .font(.body)
                    .foregroundColor(.gray)
                
                Button("Sign Up") {
                    // Later navigate to sign up page
                }
                .font(.custom("Helvetica-Bold", size: 16))
                .foregroundColor(Color(hex: "#9FAEAB"))
            }
            .padding(.top, 5)
            
            
            HStack {
                Button("Forgot Password") {
                    // Navigate to Forgot Password screen
                }
                .foregroundColor(Color(hex: "#9FAEAB"))
                .multilineTextAlignment(.center)
                .font(.headline)
            }
            .padding(.top, 2)
            
            
            // Guest Login Button
            Button("Continue as Guest") {
                // Action to continue as guest
            }
            .foregroundColor(Color(hex: "#9FAEAB"))
            .multilineTextAlignment(.center)
            .font(.headline)
            .padding(.top, 20)
            
            Spacer()
            
           
        }
        .padding()
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
