import SwiftUI

struct RootTabView: View {
    
    @ObservedObject var appSession: AppSession
    let container: AppContainer
    private let currentUserId: String

    init(currentUserId: String, appSession: AppSession, container: AppContainer) {
        self.currentUserId = currentUserId
        self.appSession = appSession
        self.container = container
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea()
            
            TabView {
                // PING VIEW TAB
                NavigationStack {
                    PingsView(viewModel: container.pingsViewModel, currentUserId: currentUserId, container: container)
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
                
                // PING UPDATE VIEW TAB
                NavigationStack {
                    SettingsView(appSession: appSession)
                }
                .tabItem {
                    Label("Setting", systemImage: "gearshape.fill")
                }
            }
            .tint(.white)
            
        }
    }
}
