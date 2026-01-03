import SwiftUI
import AppContainer

public struct RegisterFlow: View {
    private let onAuthSuccess: @MainActor () -> Void
    private let onGoToLogin: @MainActor () -> Void

    @StateObject private var viewModel: RegisterViewModel

    public init(
        onAuthSuccess: @escaping @MainActor () -> Void,
        onGoToLogin: @escaping @MainActor () -> Void
    ) {
        self.onAuthSuccess = onAuthSuccess
        self.onGoToLogin = onGoToLogin

        let container = AppContainer.shared
        _viewModel = StateObject(
            wrappedValue: RegisterViewModel(
                registerAPI: container.registerAPI,
                tokenStore: container.tokenStore,
                onRegistered: onAuthSuccess,
                onGoToLogin: onGoToLogin
            )
        )
    }

    public var body: some View {
        RegisterView(viewModel: viewModel)
    }
}
