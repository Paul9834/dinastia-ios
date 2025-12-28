import Foundation
import CoreModels
import CoreNetworking
import CorePersistence

@MainActor
public final class LoginViewModel: ObservableObject {
    // // Inputs
    @Published public var email: String = ""
    @Published public var password: String = ""

    // // UI State
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?

    // // Dependencias
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
        // // Reset de error
        errorMessage = nil

        // // Sanitizar inputs
        let e = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let p = password.trimmingCharacters(in: .whitespacesAndNewlines)

        // // Validación básica
        guard !e.isEmpty, !p.isEmpty else {
            errorMessage = "Completa el correo y la contraseña."
            return
        }

        // // Loading ON
        isLoading = true
        defer { isLoading = false }

        do {
            // // Llamado a login
            let response = try await authAPI.login(.init(correo: e, contrasena: p))

            // // Guardar token en Keychain
            try tokenStore.save(response.token)

            // // Notificar éxito (cambio de flujo)
            onAuthed()
        } catch {
            errorMessage = "No se pudo iniciar sesión. Verifica tus datos e intenta de nuevo."
        }
    }
}
