import SwiftUI
import CoreNetworking
import CorePersistence

public struct AuthFlow: View {
    // // Callback para avisarle al RootView que ya hay sesión
    private let onAuthed: @MainActor () -> Void

    // // ViewModel dueño del estado del login
    @StateObject private var viewModel: LoginViewModel

    // // Inyección desde el proyecto main (AppContainer)
    public init(
        authAPI: AuthAPIProtocol,
        tokenStore: TokenStore,
        onAuthed: @escaping @MainActor () -> Void
    ) {
        // // Guardamos callback
        self.onAuthed = onAuthed

        // // Creamos el ViewModel una sola vez (StateObject)
        _viewModel = StateObject(
            wrappedValue: LoginViewModel(
                authAPI: authAPI,
                tokenStore: tokenStore,
                onAuthed: onAuthed
            )
        )
    }

    public var body: some View {
        // // LoginView ahora recibe el viewModel (no Binding)
        LoginView(viewModel: viewModel)
    }
}
