import SwiftUI

struct RootView: View {

    @ObservedObject var appSession: AppSession

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
