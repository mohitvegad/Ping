import SwiftUI
import FirebaseCore

@main
struct PingApp: App {
    
    @StateObject private var appState = AppState()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        
        WindowGroup {
            RootView(appState: appState)
                .environmentObject(appState)
                .onAppear {
                    appState.start()
                }
        }
    }
}
