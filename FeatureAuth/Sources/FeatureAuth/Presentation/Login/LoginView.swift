import SwiftUI

public struct LoginView: View {
    // // El dueño real del VM es AuthFlow, aquí solo lo observamos
    @ObservedObject private var viewModel: LoginViewModel

    @State private var isPasswordVisible = false
    private let brandGreen = Color(red: 0.22, green: 0.47, blue: 0.28)

    public init(viewModel: LoginViewModel) {
        // // Guardamos la referencia al VM que nos inyectan
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
            .background(background)
        }
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
            HStack(spacing: 12) {
                Image(systemName: "envelope.fill").foregroundStyle(.secondary)

                TextField("Correo electrónico*", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
            }
            .fieldPill()

            HStack(spacing: 12) {
                Image(systemName: "lock.fill").foregroundStyle(.secondary)

                if isPasswordVisible {
                    TextField("Contraseña*", text: $viewModel.password)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } else {
                    SecureField("Contraseña*", text: $viewModel.password)
                }

                Button {
                    // // Toggle para ver/ocultar contraseña
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
            .fieldPill()

            if let msg = viewModel.errorMessage {
                Text(msg)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.top, 10)
    }

    private var primaryButton: some View {
        Button {
            // // Dispara el login en async
            Task { await viewModel.loginTapped() }
        } label: {
            ZStack {
                Text("INGRESAR")
                    .font(.system(size: 18, weight: .bold))
                    .opacity(viewModel.isLoading ? 0 : 1)

                if viewModel.isLoading {
                    ProgressView().tint(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
        }
        .buttonStyle(.plain)
        .background(brandGreen)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .disabled(viewModel.isLoading)
        .padding(.top, 14)
    }

    private var actions: some View {
        HStack { Spacer(); Text("¿Olvidaste tu contraseña?").foregroundStyle(.secondary) }
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
    func fieldPill() -> some View {
        self
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                    .glassify()
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .strokeBorder(.quaternary, lineWidth: 1)
            )
    }

    @ViewBuilder
    func glassify() -> some View {
        // // Glass effect solo si está disponible
        if #available(iOS 26.0, *) { self.glassEffect() } else { self }
    }
}
