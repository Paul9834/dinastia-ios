import SwiftUI
import FeatureAuth
import FeatureRegister
import AppContainer
import CorePersistence
struct RootView: View {

    // // Estado global simple: o estás en auth o estás en main
    @State private var route: AppRoute = .auth

    // // Para que el bootstrap (leer token) corra solo una vez
    @State private var didBootstrap = false
    
    
    

    var body: some View {
        
        
        Group {
            switch route {

            case .auth:
                // // Muestra el flujo de autenticación (login/register)
                AuthFlow(

                    // // Este closure es “el evento global de éxito”
                    // // Si login o register guardan token y disparan esto → pasamos a main
                    onAuthSuccess: {
                        route = .main
                    },

                    // // Factory: aquí RootView le dice a AuthFlow
                    // // “cuando necesites pantalla de register, créala así”
                    makeRegister: { onAuthSuccess, onGoToLogin in
                        RegisterFlow(

                            // // Importante:
                            // // RegisterFlow recibe el MISMO closure de éxito global.
                            // // Cuando el RegisterViewModel hace onAuthSuccess(),
                            // // termina ejecutando route = .main (arriba).
                            onAuthSuccess: onAuthSuccess,

                            // // Esta acción solo vuelve a login dentro del AuthFlow
                            // // (pop de navegación)
                            onGoToLogin: onGoToLogin
                        )
                    }
                )

            case .main:
                
            
                // // Flujo principal ya autenticado
                MainFlow(
                    onLogout: {
                        // // Limpia token persistido → la app queda “deslogueada”
                        try? AppContainer.shared.tokenStore.clear()
                        // // Vuelve al flujo de auth
                        route = .auth
                    }
                )
            }
        }
        .task {
            // // Bootstrap: al abrir la app, mirar si hay token guardado
            guard !didBootstrap else { return }
            didBootstrap = true

            let token = try? AppContainer.shared.tokenStore.load()

            debugInfoPlist()

            
            // // Si hay token → arrancamos directo en main.
            // // Si no hay token → mostramos auth.
            route = (token?.isEmpty == false) ? .main : .auth
        }
    }
    
    private func debugInfoPlist() {
            let info = Bundle.main.infoDictionary

            print("✅ BUNDLE:", Bundle.main.bundleIdentifier ?? "nil")
            print("✅ INFOPLIST FILE KEYS:", info?.keys.sorted() ?? [])
            print("✅ ATS:", info?["NSAppTransportSecurity"] ?? "NO ATS FOUND")
        }
    
    
}

enum AppRoute {
    case auth
    case main
}
