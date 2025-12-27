import SwiftUI

struct MainFlow: View {
    let onLogout: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Home")
                Button("Cerrar sesión") { onLogout() }
            }
            .padding()
        }
    }
}
