import SwiftUI



public struct AuthFlow<RegisterScreen: View>: View {
    private let onAuthSuccess: @MainActor () -> Void
    private let makeRegister: (
        @escaping @MainActor () -> Void,
        @escaping @MainActor () -> Void
    ) -> RegisterScreen

    @State private var path = NavigationPath()

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
            LoginFlow(
                onAuthSuccess: onAuthSuccess,
                onGoToRegister: { path.append(AuthRoute.register) }
            )
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
