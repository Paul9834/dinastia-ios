import SwiftUI
import FeatureAuth

struct RootView: View {
    @State private var route: AppRoute = .auth

    var body: some View {
        switch route {
        case .auth:
            AuthFlow(onAuthed: { route = .main })
        case .main:
            MainFlow(onLogout: { route = .auth })
        }
    }
}

enum AppRoute {
    case auth
    case main
}
