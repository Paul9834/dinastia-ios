import SwiftUI

struct SplashView: View {
    @Binding var didFinish: Bool

    private let brandGreen = Color(red: 0.22, green: 0.47, blue: 0.28)

    @State private var scale: CGFloat = 0.92
    @State private var opacity: CGFloat = 0.0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    brandGreen.opacity(0.10),
                    Color(.systemBackground),
                    Color(.systemBackground)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(brandGreen.opacity(0.14))
                        .frame(width: 116, height: 116)
                        .glassify()

                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundStyle(brandGreen)
                }

                Text("Dinastía")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
            }
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .task {
            withAnimation(.easeOut(duration: 0.35)) {
                opacity = 1
                scale = 1
            }

            try? await Task.sleep(nanoseconds: 1_100_000_000)

            withAnimation(.easeInOut(duration: 0.25)) {
                didFinish = true
            }
        }
    }
}

private extension View {
    @ViewBuilder
    func glassify() -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect()
        } else {
            self
        }
    }
}
