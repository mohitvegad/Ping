import SwiftUI
import Firebase
@main
struct PingApp: App {
    
    init() {
        FirebaseApp.configure()

        if !UserDefaults.standard.bool(forKey: "didSeedUsers") {
            UserSeeder().seedUsers()
            UserDefaults.standard.set(true, forKey: "didSeedUsers")
        }
        
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
