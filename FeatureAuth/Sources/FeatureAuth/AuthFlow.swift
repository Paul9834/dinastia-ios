import SwiftUI
import AppContainer
import CorePersistence

public struct AuthFlow: View {
    // // Callback para avisar que ya se autenticó
    private let onAuthed: @MainActor () -> Void

    // // El ViewModel debe vivir mientras viva el AuthFlow
    @StateObject private var viewModel: LoginViewModel

    public init(onAuthed: @escaping @MainActor () -> Void) {
        // // Guardamos callback
        self.onAuthed = onAuthed

        // // Traemos dependencias del contenedor
        let container = AppContainer.shared

        // // Creamos el VM una sola vez (StateObject)
        _viewModel = StateObject(
            wrappedValue: LoginViewModel(
                authAPI: container.authAPI,
                tokenStore: container.tokenStore,
                onAuthed: onAuthed
            )
        )
    }

    public var body: some View {
        // // Montamos el login con el VM “estable”
        LoginView(viewModel: viewModel)
    }
}
