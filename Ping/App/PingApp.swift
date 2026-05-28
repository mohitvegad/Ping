import SwiftUI
import Firebase
import FirebaseAuth

@main
struct PingApp: App {

    @StateObject private var appState = AppState()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if appState.isReady {
                RootTabView()
                    .preferredColorScheme(.dark)
            } else {
                ProgressView("Loading...")
                    .onAppear {
                        appState.start()
                    }
            }
        }
    }
}
