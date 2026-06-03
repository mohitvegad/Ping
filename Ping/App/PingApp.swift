import SwiftUI
import FirebaseCore

@main
struct PingApp: App {
    
    @StateObject private var appState: AppState
    
    // MARK: - INIT
    
    init() {
        
        FirebaseApp.configure()
        
        let authService = FirebaseAuthService()
        let authRepository = AuthRepository(authService: authService)
        
        _appState = StateObject(wrappedValue: AppState(repository: authRepository))
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
