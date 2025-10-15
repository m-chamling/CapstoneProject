import SwiftUI

struct AuthFlowView: View {
    var body: some View {
        // Your welcome → get started → login/signup path lives here
        NavigationStack {
            WelcomePage()   // <- you already have this
        }
    }
}

