import SwiftUI
import FeatureAuth
import FeatureRegister
import AppContainer
import CorePersistence

struct RootView: View {
    @State private var route: AppRoute = .auth
    @State private var didBootstrap = false

    var body: some View {
        Group {
            switch route {
            case .auth:
                AuthFlow(
                    onAuthSuccess: { route = .main },
                    makeRegister: { onAuthSuccess, onGoToLogin in
                        RegisterFlow(
                            onAuthSuccess: onAuthSuccess,
                            onGoToLogin: onGoToLogin
                        )
                    }
                )

            case .main:
                MainFlow(onLogout: {
                    try? AppContainer.shared.tokenStore.clear()
                    route = .auth
                })
            }
        }
        .task {
            guard !didBootstrap else { return }
            didBootstrap = true

            let token = try? AppContainer.shared.tokenStore.load()
            route = (token?.isEmpty == false) ? .main : .auth
        }
    }
}

enum AppRoute {
    case auth
    case main
}
