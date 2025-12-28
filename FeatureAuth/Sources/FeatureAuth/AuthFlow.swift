import SwiftUI
import AppContainer
import FeatureAuth

public struct AuthFlow: View {
    private let onAuthed: @MainActor () -> Void

    public init(onAuthed: @escaping @MainActor () -> Void) {
        self.onAuthed = onAuthed
    }

    public var body: some View {
        // // Traemos dependencias del contenedor
        let container = AppContainer.shared

        // // Creamos el ViewModel inyectando AuthAPI + TokenStore + callback
        let vm = LoginViewModel(
            authAPI: container.authAPI,
            tokenStore: container.tokenStore,
            onAuthed: onAuthed
        )

        // // Montamos el LoginView real
        LoginView(viewModel: vm)
    }
}
