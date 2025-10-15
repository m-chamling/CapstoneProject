import SwiftUI

struct ChangePasswordView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationView {
            
            VStack {
                
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
                    .padding(.top, 40)
                
                // App Title
                Text("PawRescue")
                    .font(.custom("Helvetica-Bold", size: 22))
                    .padding(.top, 5)
                    .foregroundColor(Color(hex: "#312F30"))
                    .kerning(0.2)
                    .lineSpacing(30)
                    .padding(.top, 0)
                
                

                // Main Title (Login)
                Text("Create new Password")
                    .font(.custom("Helvetica-Bold", size: 27))
                    .padding(.top, 100)
                    .foregroundColor(Color(hex: "#312F30"))
                    .kerning(0.2)
                    .lineSpacing(30)
                    .padding(.top, 0)
                
                // Description Text
                Text("Your new password must be different from your previous used password.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.top, 0.5)
                
                
                
                // Email Field
                TextField("Email", text: $email)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .cornerRadius(30)

                // Password Field
                SecureField("Password", text: $password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .cornerRadius(30)

                // Change Password Button
                Button(action: {
                    // Add your change password logic here
                }) {
                    Text("Change Password")
                        .font(.custom("Helvetica-Bold", size: 19))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color(hex: "#312F30"))
                        .cornerRadius(30)
                        .padding(.horizontal, 30)
                }
                .padding(.top, 20)

                Spacer()

            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
