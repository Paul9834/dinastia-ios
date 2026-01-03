import SwiftUI
import AppContainer

public struct LoginFlow: View {
    private let onAuthSuccess: @MainActor () -> Void
    private let onGoToRegister: @MainActor () -> Void

    @StateObject private var viewModel: LoginViewModel

    public init(
        onAuthSuccess: @escaping @MainActor () -> Void,
        onGoToRegister: @escaping @MainActor () -> Void
    ) {
        self.onAuthSuccess = onAuthSuccess
        self.onGoToRegister = onGoToRegister

        let container = AppContainer.shared
        _viewModel = StateObject(
            wrappedValue: LoginViewModel(
                authAPI: container.authAPI,
                tokenStore: container.tokenStore,
                onAuthed: onAuthSuccess
            )
        )
    }

    public var body: some View {
        LoginView(
            viewModel: viewModel,
            onGoToRegister: { onGoToRegister() }
        )
    }
}
