import SwiftUI

struct RootTabView: View {
    
    @ObservedObject var appSession: AppSession
    private let currentUserId: String

    init(currentUserId: String, appSession: AppSession) {
         self.currentUserId = currentUserId
         self.appSession = appSession
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.ignoresSafeArea()
            
            let service = ChatService()
            let repository = ChatRepository(service: service)
            let viewModel = PingsViewViewModel(repository: repository)

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
