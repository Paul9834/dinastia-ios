import SwiftUI
import DesignSystem

public struct LoginView: View {

    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case email
        case password
    }

    @ObservedObject private var viewModel: LoginViewModel
    @State private var isPasswordVisible = false
    private let onGoToRegister: () -> Void

    public init(viewModel: LoginViewModel, onGoToRegister: @escaping () -> Void = {}) {
        self.viewModel = viewModel
        self.onGoToRegister = onGoToRegister
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.stack) {
                hero
                fields
                actions
                primaryButton
                footer
                Spacer(minLength: 24)
            }
            .padding(.horizontal, DSSpacing.screenHorizontal)
            .padding(.top, 16)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .background(DSAuthBackground(accent: DSBrand.green))
        .onAppear { focusedField = .email }
    }

    private var hero: some View {
        VStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: DSRadius.iconTile, style: .continuous)
                    .fill(.thinMaterial)
                    .frame(width: 112, height: 112)
                    .overlay {
                        RoundedRectangle(cornerRadius: DSRadius.iconTile, style: .continuous)
                            .stroke(.white.opacity(0.22), lineWidth: 1)
                    }
                    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 8)

                Image(systemName: "pawprint.fill")
                    .font(.system(size: 42, weight: .semibold))
                    .foregroundStyle(DSBrand.green)
            }

            Text("Bienvenido")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundStyle(DSBrand.green)

            Text("Ingresa a tu cuenta para gestionar tus\nmascotas")
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, DSSpacing.heroTop)
        .padding(.bottom, 10)
    }

    private var fields: some View {
        VStack(spacing: 16) {

            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.secondary)

                TextField("Correo electrónico*", text: $viewModel.email)
                    .font(.system(size: 17))
                    .padding(.vertical, 14)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .email)
                    .onSubmit { focusedField = .password }
                    .tint(DSBrand.green)
            }
            .padding(.horizontal, DSSpacing.fieldHorizontal)
            .dsFieldPill(isFocused: focusedField == .email, accent: DSBrand.green)

            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.secondary)

                Group {
                    if isPasswordVisible {
                        TextField("Contraseña*", text: $viewModel.password)
                    } else {
                        SecureField("Contraseña*", text: $viewModel.password)
                    }
                }
                .font(.system(size: 17))
                .padding(.vertical, 14)
                .submitLabel(.go)
                .focused($focusedField, equals: .password)
                .onSubmit { submitLogin() }
                .tint(DSBrand.green)

                Button { isPasswordVisible.toggle() } label: {
                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, DSSpacing.fieldHorizontal)
            .dsFieldPill(isFocused: focusedField == .password, accent: DSBrand.green)

            if let msg = viewModel.errorMessage {
                Text(msg)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.top, 10)
    }

    private var actions: some View {
        HStack {
            Text("¿Olvidaste tu contraseña?")
                .foregroundStyle(.secondary)
        }
    }

    private var primaryButton: some View {
        DSPrimaryButton(
            "INGRESAR",
            isLoading: viewModel.isLoading,
            isDisabled: viewModel.isLoading,
            background: DSBrand.green
        ) {
            submitLogin()
        }
        .padding(.top, 14)
    }

    private var footer: some View {
        HStack(spacing: 6) {
            Text("¿No tienes cuenta?")
                .foregroundStyle(.secondary)

            Button { onGoToRegister() } label: {
                Text("Regístrate")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(DSBrand.green)
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 10)
    }

    private func submitLogin() {
        guard !viewModel.isLoading else { return }
        focusedField = nil
        Task { await viewModel.loginTapped() }
    }
}
