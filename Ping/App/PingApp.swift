import SwiftUI
import FirebaseCore

@main
struct PingApp: App {
    
    @StateObject private var appSession: AppSession
    
    // MARK: - INIT
    
    init() {
        FirebaseApp.configure()
        
        let authService = FirebaseAuthService()
        let authRepository = AuthRepository(authService: authService)
        let keyChainService = KeychainManager.shared
        let userSession = CurrentUserSession.shared
        let userStore = UserStore.shared
        
        _appSession = StateObject(wrappedValue: AppSession(repository: authRepository, keyChain: keyChainService, userSession: userSession, userStore: userStore))
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(appSession: appSession)
                .environmentObject(appSession)
                .onAppear {
                    appSession.start()
                }
        }
    }
}
