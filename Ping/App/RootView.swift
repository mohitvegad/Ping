import SwiftUI

struct RootView: View {

    @ObservedObject var appSession: AppSession

    //---------------------------
    // Body
    //---------------------------
    
    var body: some View {

        switch appSession.state {

        case .idle:
            ProgressView()

        case .loggedOut:
            LoginView(appSession: appSession) 

        case .loggedIn(let uid):
            RootTabView(currentUserId: uid, appSession: appSession)
        }
    }
}
