import SwiftUI

public struct LoginView: View {

    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case email
        case password
    }

    @ObservedObject private var viewModel: LoginViewModel

    @State private var isPasswordVisible = false
    private let brandGreen = Color(red: 0.22, green: 0.47, blue: 0.28)

    public init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    hero
                    fields
                    actions
                    primaryButton
                    footer
                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .background(background)
        }
        .onAppear { focusedField = .email }
    }

    private var hero: some View {
        VStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(brandGreen.opacity(0.12))
                    .frame(width: 112, height: 112)
                    .glassify()

                Image(systemName: "pawprint.fill")
                    .font(.system(size: 42, weight: .semibold))
                    .foregroundStyle(brandGreen)
            }

            Text("Bienvenido")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundStyle(brandGreen)

            Text("Ingresa a tu cuenta para gestionar tus\nmascotas")
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 26)
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
            }
            .fieldPill(isFocused: focusedField == .email)

            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.secondary)

                if isPasswordVisible {
                    TextField("Contraseña*", text: $viewModel.password)
                        .font(.system(size: 17))
                        .padding(.vertical, 14)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .submitLabel(.go)
                        .focused($focusedField, equals: .password)
                        .onSubmit { submitLogin() }
                } else {
                    SecureField("Contraseña*", text: $viewModel.password)
                        .font(.system(size: 17))
                        .padding(.vertical, 14)
                        .submitLabel(.go)
                        .focused($focusedField, equals: .password)
                        .onSubmit { submitLogin() }
                }

                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .fieldPill(isFocused: focusedField == .password)

            if let msg = viewModel.errorMessage {
                Text(msg)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.top, 10)
    }

    private func submitLogin() {
        guard !viewModel.isLoading else { return }
        focusedField = nil
        Task { await viewModel.loginTapped() }
    }

    private var primaryButton: some View {
        Button {
            submitLogin()
        } label: {
            ZStack {
                Text("INGRESAR")
                    .font(.system(size: 18, weight: .bold))
                    .opacity(viewModel.isLoading ? 0 : 1)

                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(brandGreen)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isLoading)
        .padding(.top, 14)
    }

    private var actions: some View {
        HStack {
            Text("¿Olvidaste tu contraseña?")
                .foregroundStyle(.secondary)
        }
    }

    private var footer: some View {
        Text("¿No tienes cuenta? Regístrate")
            .foregroundStyle(.secondary)
            .padding(.top, 10)
    }

    private var background: some View {
        LinearGradient(
            colors: [brandGreen.opacity(0.05), Color(.systemBackground)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

private extension View {

    func fieldPill(isFocused: Bool) -> some View {
        self
            .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                    .applyGlassBackground()
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(isFocused ? Color.white.opacity(0.28) : Color.white.opacity(0.14), lineWidth: 1)
            )
    }

    @ViewBuilder
    func applyGlassBackground() -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect()
        } else {
            self
                .background(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 10)
        }
    }

    @ViewBuilder
    func glassify() -> some View {
        if #available(iOS 26.0, *) { self.glassEffect() } else { self }
    }
}
