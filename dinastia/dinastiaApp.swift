import SwiftUI

@main
struct dinastiaApp: App {
    @State private var didFinishSplash = false

    var body: some Scene {
        WindowGroup {
            if didFinishSplash {
                RootView()
            } else {
                SplashView(didFinish: $didFinishSplash)
            }
        }
    }
}
