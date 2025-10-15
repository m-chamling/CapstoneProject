import SwiftUI

struct WelcomePage: View {
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 85, height: 85)
                .padding(.top, 300)

            Text("PawRescue")
                .font(.custom("Helvetica-Bold", size: 25))
                .padding(.top, 15)
                .foregroundColor(Color(hex: "#312F30"))

            Text("Are you ready to rescue animals?")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 3)

            Spacer()

            // 👉 Go straight to LoginView
            NavigationLink {
                LoginView()
            } label: {
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

// Preview with its own NavigationStack just for the canvas
#Preview {
    NavigationStack { WelcomePage() }
}
