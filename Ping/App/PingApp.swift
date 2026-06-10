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
        let keyChainService = KeychainManager.shared
        let userSession = CurrentUserSession.shared
        let userStore = UserStore.shared
        
        _appState = StateObject(wrappedValue: AppState(repository: authRepository, keyChain: keyChainService, userSession: userSession, userStore: userStore))
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
