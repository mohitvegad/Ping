import SwiftUI
import Firebase
@main
struct PingApp: App {
    
    init() {
        
        if !UserDefaults.standard.bool(forKey: "didSeedUsers") {
            UserSeeder().seedUsers()
            UserDefaults.standard.set(true, forKey: "didSeedUsers")
        }
        
        FirebaseApp.configure()
    }
    //    init() {
    //
    //        let appearance = UINavigationBarAppearance()
    //        appearance.configureWithOpaqueBackground()
    //        appearance.backgroundColor = .black
    //        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    //
    //        UINavigationBar.appearance().standardAppearance = appearance
    //        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    //        UINavigationBar.appearance().compactAppearance = appearance
    //    }
    
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .preferredColorScheme(.dark)
        }
    }
}
