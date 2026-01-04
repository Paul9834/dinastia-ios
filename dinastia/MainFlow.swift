import SwiftUI
import DesignSystem

struct MainFlow: View {
    let onLogout: () -> Void

    var body: some View {
        MainTabView(onLogout: onLogout)
    }
}
