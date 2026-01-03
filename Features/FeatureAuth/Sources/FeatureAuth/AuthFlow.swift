import SwiftUI

public struct AuthFlow<RegisterScreen: View>: View {

    // // Callback global: “ya hay token, ya estoy autenticado”
    private let onAuthSuccess: @MainActor () -> Void

    // // Factory: RootView “inyecta” qué pantalla de Register usar
    private let makeRegister: (
        @escaping @MainActor () -> Void,
        @escaping @MainActor () -> Void
    ) -> RegisterScreen

    // // Navigation interna del AuthFlow
    @State private var path = NavigationPath()

    // // Init con makeRegister
    public init(
        onAuthSuccess: @escaping @MainActor () -> Void,
        makeRegister: @escaping (
            @escaping @MainActor () -> Void,
            @escaping @MainActor () -> Void
        ) -> RegisterScreen
    ) {
        self.onAuthSuccess = onAuthSuccess
        self.makeRegister = makeRegister
    }

    public var body: some View {
        NavigationStack(path: $path) {

            // // Pantalla de login (inicio del flow)
            LoginFlow(
                onAuthSuccess: onAuthSuccess,
                onGoToRegister: { path.append(AuthRoute.register) }
            )
            // // Destino register dentro del mismo NavigationStack
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .register:
                    makeRegister(
                        onAuthSuccess,
                        { if !path.isEmpty { path.removeLast() } }
                    )
                }
            }
        }
    }
}

