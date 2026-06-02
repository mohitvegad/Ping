import SwiftUI

struct RootTabView: View {
    
    private let currentUserId: String

    init(currentUserId: String) {
        self.currentUserId = currentUserId

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.black)
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.gray)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea()
            
            TabView {
                // PING VIEW TAB
                NavigationStack {
                    PingsView(currentUserId: currentUserId)
                }
                .tabItem {
                    Label("Pings", systemImage: "message.fill")
                }
                
                // PING UPDATE VIEW TAB
                NavigationStack {
                    PingUpdateView()
                }
                .tabItem {
                    Label("Updates", systemImage: "circle.dashed")
                }
            }
            .tint(.white)
            
        }
    }
}
