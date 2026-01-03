//
//  RegisterViewModel.swift
//  FeatureRegister
//
//  Created by Paul Montealegre on 02/01/2026.
//

import Foundation
import CoreModels
import CorePersistence
import CoreFoundationKit
import CoreNetworking


@MainActor
public final class RegisterViewModel: ObservableObject {
    // // Inputs
    @Published public var firstName: String = ""
    @Published public var lastName: String = ""
    @Published public var phone: String = ""
    @Published public var email: String = ""
    @Published public var password: String = ""

    // // UI State
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?

    // // Dependencias
    private let registerAPI: RegisterApiProtocol
    private let tokenStore: TokenStore
    private let onRegistered: @MainActor () -> Void
    private let onGoToLogin: @MainActor () -> Void

    public init(
        registerAPI: RegisterApiProtocol,
        tokenStore: TokenStore,
        onRegistered: @escaping @MainActor () -> Void,
        onGoToLogin: @escaping @MainActor () -> Void
    ) {
        self.registerAPI = registerAPI
        self.tokenStore = tokenStore
        self.onRegistered = onRegistered
        self.onGoToLogin = onGoToLogin
    }

    public func registerTapped() async {
        errorMessage = nil

        let fn = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let ln = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let ph = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        let e = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let p = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !fn.isEmpty, !ln.isEmpty, !ph.isEmpty, !e.isEmpty, !p.isEmpty else {
            errorMessage = "Completa todos los campos para registrarte."
            return
        }

        guard e.contains("@"), e.contains(".") else {
            errorMessage = "Ingresa un correo válido."
            return
        }

        guard p.count >= 6 else {
            errorMessage = "La contraseña debe tener al menos 6 caracteres."
            return
        }

        isLoading = true
        defer { isLoading = false }

        Log.d("RegisterTapped nombre=\(fn) \(ln) email=\(e) phone=\(String(ph.prefix(4)))…")

        do {
            let api = registerAPI

            let response = try await Task.detached(priority: .userInitiated) {
                try await api.register(.init(
                    nombre: fn,
                    apellido: ln,
                    correo: e,
                    telefono: ph,
                    contrasena: p,
                    rolNombre: "CLIENTE"
                ))
            }.value

            try tokenStore.save(response.token)
            onRegistered()

        } catch {
            errorMessage = "No se pudo crear la cuenta. Verifica tus datos e intenta de nuevo."
        }
    }

    public func loginLinkTapped() {
        onGoToLogin()
    }
}
