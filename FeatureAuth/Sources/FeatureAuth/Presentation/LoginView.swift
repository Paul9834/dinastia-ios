import SwiftUI

public struct LoginView: View {
    @Binding private var isLoggedIn: Bool

    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var isLoading = false
    @State private var errorMessage: String?

    private let brandGreen = Color(red: 0.22, green: 0.47, blue: 0.28)

    public init(isLoggedIn: Binding<Bool>) {
        self._isLoggedIn = isLoggedIn
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    header
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .tint(brandGreen)
                }
            }
        }
    }

    private var header: some View {
        Color.clear
            .frame(height: 8)
    }

    private var hero: some View {
        VStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(brandGreen.opacity(0.12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .strokeBorder(brandGreen.opacity(0.18), lineWidth: 1)
                    }
                    .frame(width: 112, height: 112)
                    .glassify()

                Image(systemName: "pawprint.fill")
                    .font(.system(size: 42, weight: .semibold))
                    .foregroundStyle(brandGreen)
            }

            Text("Bienvenido")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundStyle(brandGreen)
                .multilineTextAlignment(.center)

            Text("Ingresa a tu cuenta para gestionar tus\nmascotas")
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
        .padding(.top, 26)
        .padding(.bottom, 10)
    }

    private var fields: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "envelope.fill")
                    .foregroundStyle(.secondary)

                TextField("Correo electrónico*", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
            }
            .fieldPill()

            HStack(spacing: 12) {
                Image(systemName: "lock.fill")
                    .foregroundStyle(.secondary)

                Group {
                    if isPasswordVisible {
                        TextField("Contraseña*", text: $password)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    } else {
                        SecureField("Contraseña*", text: $password)
                    }
                }
                .submitLabel(.go)

                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isPasswordVisible ? "Ocultar contraseña" : "Mostrar contraseña")
            }
            .fieldPill()

            if let msg = errorMessage {
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
            Spacer()
            Button("¿Olvidaste tu contraseña?") {
            }
            .font(.system(size: 16, weight: .regular))
            .foregroundStyle(.secondary)
        }
        .padding(.top, 2)
    }

    private var primaryButton: some View {
        Button {
            Task { await submit() }
        } label: {
            ZStack {
                Text("INGRESAR")
                    .font(.system(size: 18, weight: .bold))
                    .opacity(isLoading ? 0 : 1)

                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
        }
        .buttonStyle(.plain)
        .background(brandGreen)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: brandGreen.opacity(0.25), radius: 18, x: 0, y: 10)
        .padding(.top, 14)
        .disabled(isLoading)
        .accessibilityHint("Iniciar sesión")
    }

    private var footer: some View {
        HStack(spacing: 8) {
            Text("¿No tienes cuenta?")
                .foregroundStyle(.secondary)

            Button("Regístrate") {
            }
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(brandGreen)
        }
        .font(.system(size: 18, weight: .regular))
        .padding(.top, 10)
    }

    private var background: some View {
        LinearGradient(
            colors: [
                brandGreen.opacity(0.05),
                Color(.systemBackground),
                Color(.systemBackground)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    @MainActor
    private func submit() async {
        errorMessage = nil

        let e = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let p = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !e.isEmpty, !p.isEmpty else {
            errorMessage = "Completa el correo y la contraseña."
            return
        }

        isLoading = true
        try? await Task.sleep(nanoseconds: 700_000_000)
        isLoading = false
        isLoggedIn = true
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
        if #available(iOS 26.0, *) {
            self.glassEffect()
        } else {
            self
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}
