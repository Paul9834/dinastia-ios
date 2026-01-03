import Foundation
import CoreModels
import CoreNetworking
import CorePersistence
import CoreFoundationKit

@MainActor
public final class LoginViewModel: ObservableObject {
    @Published public var email: String = ""
    @Published public var password: String = ""

    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?

    private let authAPI: AuthAPIProtocol
    private let tokenStore: TokenStore
    private let onAuthed: @MainActor () -> Void

    public init(
        authAPI: AuthAPIProtocol,
        tokenStore: TokenStore,
        onAuthed: @escaping @MainActor () -> Void
    ) {
        self.authAPI = authAPI
        self.tokenStore = tokenStore
        self.onAuthed = onAuthed
    }

    public func loginTapped() async {
        errorMessage = nil

        let e = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let p = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !e.isEmpty, !p.isEmpty else {
            errorMessage = "Completa el correo y la contraseña."
            return
        }

        isLoading = true
        defer { isLoading = false }

        Log.d("LoginTapped email=\(e)")

        do {
            let api = authAPI

            let response = try await Task.detached(priority: .userInitiated) {
                try await api.login(.init(correo: e, contrasena: p))
            }.value

            try tokenStore.save(response.token)

            let tokenPreview = String(response.token.prefix(12))
            Log.d("Token recibido: \(tokenPreview)… len=\(response.token.count)")

            let stored = try tokenStore.load()
            Log.d("Token en Keychain: \(String((stored ?? "").prefix(12)))…")

            onAuthed()
        } catch {
            errorMessage = "No se pudo iniciar sesión. Verifica tus datos e intenta de nuevo."
        }
    }
}
