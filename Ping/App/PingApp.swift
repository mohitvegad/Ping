import SwiftUI
import FirebaseCore

@main
struct PingApp: App {
    
    @StateObject private var appConfig: AppConfiguration
    
    // MARK: - INIT
    
    init() {
        FirebaseApp.configure()
        
        let authService = FirebaseAuthService()
        let authRepository = AuthRepository(authService: authService)
        let keyChainService = KeychainManager.shared
        let userSession = CurrentUserSession.shared
        let userStore = UserStore.shared
        
        _appConfig = StateObject(wrappedValue: AppConfiguration(repository: authRepository, keyChain: keyChainService, userSession: userSession, userStore: userStore))
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(appConfig: appConfig)
                .environmentObject(appConfig)
                .onAppear {
                    appConfig.start()
                }
        }
    }
}
