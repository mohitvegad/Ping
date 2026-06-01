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
            LoginView()

//            if appState.isReady {
////                RootTabView()
//                LoginView()
//                    .preferredColorScheme(.dark)
//            } else {
//                ProgressView("Loading...")
//                    .onAppear {
//                        appState.start()
//                    }
//            }
        }
    }
}
