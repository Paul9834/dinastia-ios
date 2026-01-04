import SwiftUI
import DesignSystem

public struct RegisterView: View {

    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case firstName
        case lastName
        case phone
        case email
        case password
    }

    @ObservedObject private var viewModel: RegisterViewModel
    @State private var isPasswordVisible = false

    public init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.stack) {
                hero
                fields
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
        .onAppear { focusedField = .firstName }
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

                Image(systemName: "person.badge.plus.fill")
                    .font(.system(size: 42, weight: .semibold))
                    .foregroundStyle(DSBrand.green)
            }

            Text("Crear Cuenta")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundStyle(DSBrand.green)

            Text("Únete a la familia Dinastía")
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, DSSpacing.heroTop)
        .padding(.bottom, 10)
    }

    private var fields: some View {
        VStack(spacing: 16) {

            HStack(spacing: 12) {

                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.secondary)

                    TextField("Nombre*", text: $viewModel.firstName)
                        .font(.system(size: 17))
                        .padding(.vertical, 14)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .submitLabel(.next)
                        .focused($focusedField, equals: .firstName)
                        .onSubmit { focusedField = .lastName }
                        .tint(DSBrand.green)
                }
                .padding(.horizontal, DSSpacing.fieldHorizontal)
                .dsFieldPill(isFocused: focusedField == .firstName, accent: DSBrand.green)
                .frame(maxWidth: .infinity)

                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.secondary)

                    TextField("Apellido*", text: $viewModel.lastName)
                        .font(.system(size: 17))
                        .padding(.vertical, 14)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .submitLabel(.next)
                        .focused($focusedField, equals: .lastName)
                        .onSubmit { focusedField = .phone }
                        .tint(DSBrand.green)
                }
                .padding(.horizontal, DSSpacing.fieldHorizontal)
                .dsFieldPill(isFocused: focusedField == .lastName, accent: DSBrand.green)
                .frame(maxWidth: .infinity)
            }

            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "phone.fill")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.secondary)

                Text("+57")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.secondary)

                TextField("Teléfono celular*", text: $viewModel.phone)
                    .font(.system(size: 17))
                    .padding(.vertical, 14)
                    .keyboardType(.numberPad)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .phone)
                    .onChange(of: viewModel.phone) { _, newValue in
                        viewModel.phone = newValue.filter { $0.isNumber }
                    }
                    .tint(DSBrand.green)
            }
            .padding(.horizontal, DSSpacing.fieldHorizontal)
            .dsFieldPill(isFocused: focusedField == .phone, accent: DSBrand.green)

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
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.go)
                .focused($focusedField, equals: .password)
                .onSubmit { submitRegister() }
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

    private var primaryButton: some View {
        DSPrimaryButton(
            "REGISTRARSE",
            isLoading: viewModel.isLoading,
            isDisabled: viewModel.isLoading,
            background: DSBrand.green
        ) {
            submitRegister()
        }
        .padding(.top, 14)
    }

    private var footer: some View {
        HStack(spacing: 6) {
            Text("¿Ya tienes cuenta?")
                .foregroundStyle(.secondary)

            Button { viewModel.loginLinkTapped() } label: {
                Text("Inicia Sesión")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(DSBrand.green)
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 10)
    }

    private func submitRegister() {
        guard !viewModel.isLoading else { return }
        focusedField = nil
        Task { await viewModel.registerTapped() }
    }
}
