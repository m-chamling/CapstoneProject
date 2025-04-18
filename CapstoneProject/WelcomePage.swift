import SwiftUI

struct WelcomePage: View {
    var body: some View {
        VStack {
            
            // Logo/Image
            Image("logo") // Replace with your logo image asset name
                .resizable()
                .scaledToFit()
                .frame(width: 85, height: 85) // Adjust size as necessary
                .padding(.top, 300)
            
            // App Title
            Text("PawRescue")
                .font(.custom("Helvetica-Bold", size: 25))
                .padding(.top, 15)
                .foregroundColor(Color(hex: "#312F30"))
                .kerning(0.2)
                .lineSpacing(30)
                .padding(.top, 0)
            
            // Description Text
            Text("Are you ready to rescue animals?")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 3)
            
            Spacer()
            
            // Get Started Button
            Button(action: {
                // will add the later navigation here
            }) {
                Text("Get Started")
                    .font(.custom("Helvetica-Bold", size: 19))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#312F30"))
                    .cornerRadius(30)
                    .padding(.horizontal, 90)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

#Preview {
    WelcomePage()
}

