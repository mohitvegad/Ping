import SwiftUI
import FirebaseCore

@main
struct PingApp: App {
    
    @StateObject private var appSession: AppSession
    
    //---------------------------
    // INITIALIZATION
    //---------------------------
    
    init() {
        
        // MARK: Firebase Config
        FirebaseApp.configure()
        
        // MARK: APP Session
        let authService = FirebaseAuthService()
        let authRepository = AuthRepository(authService: authService)
        let keyChainService = KeychainManager.shared
        let userSession = CurrentUserSession.shared
        let userStore = UserStore.shared
        
        _appSession = StateObject(wrappedValue: AppSession(repository: authRepository, keyChain: keyChainService, userSession: userSession, userStore: userStore))
        
        // MARK: Tabbar Configure
        configureTabbar()
    }
    
    //---------------------------
    // BODY
    //---------------------------

    var body: some Scene {
        WindowGroup {
            RootView(appSession: appSession)
                .environmentObject(appSession)
                .onAppear {
                    appSession.start()
                }
        }
    }
    
    //---------------------------
    // Private
    //---------------------------

    private func configureTabbar() {
        let appearance = UITabBarAppearance()

           appearance.configureWithOpaqueBackground()

           appearance.backgroundColor = .black

           UITabBar.appearance().standardAppearance = appearance

           if #available(iOS 15.0, *) {
               UITabBar.appearance().scrollEdgeAppearance = appearance
           }

           UITabBar.appearance().unselectedItemTintColor = .gray
    }
}
