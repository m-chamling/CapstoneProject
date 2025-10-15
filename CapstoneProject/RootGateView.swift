import SwiftUI

struct RootGateView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        switch auth.state {
        case .loggedOut:
            AuthFlowView()      // 👈 shows Welcome/Login/SignUp screens
        case .guest, .loggedIn:
            MainAppView()       // 👈 shows your main tab bar (Map, Reports, Profile)
        }
    }
}
