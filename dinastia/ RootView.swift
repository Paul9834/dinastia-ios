import SwiftUI
import FeatureAuth
import AppContainer
import CorePersistence


struct RootView: View {
    // // Ruta actual de la app (auth o main)
    @State private var route: AppRoute = .auth

    var body: some View {
        switch route {
        case .auth:
            // // AuthFlow ya trae authAPI y tokenStore desde AppContainer.shared
            AuthFlow(
                onAuthed: { route = .main } // // Cambiamos a main cuando el login sea exitoso
            )

        case .main:
            // // Al cerrar sesión, borramos token y regresamos a auth
            MainFlow(onLogout: {
                try? AppContainer.shared.tokenStore.clear() // // Limpia token (Keychain)
                route = .auth // // Vuelve al flujo de autenticación
            })
        }
    }
}

// // Rutas principales de la app
enum AppRoute {
    case auth
    case main
}
