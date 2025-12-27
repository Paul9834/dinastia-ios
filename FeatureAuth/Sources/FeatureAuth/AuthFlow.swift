import SwiftUI

public struct AuthFlow: View {
    private let onAuthed: () -> Void
    @State private var isLoggedIn = false

    public init(onAuthed: @escaping () -> Void) {
        self.onAuthed = onAuthed
    }

    public var body: some View {
        LoginView(isLoggedIn: $isLoggedIn)
            .onChange(of: isLoggedIn) { _, newValue in
                if newValue { onAuthed() }
            }
    }
}
