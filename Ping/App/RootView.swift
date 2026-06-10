import SwiftUI

struct RootView: View {

    @ObservedObject var appConfig: AppConfiguration

    var body: some View {

        switch appConfig.state {

        case .idle:
            ProgressView()

        case .loggedOut:
            LoginView(appConfig: appConfig) 

        case .loggedIn(let uid):
            RootTabView(currentUserId: uid)
        }
    }
}
