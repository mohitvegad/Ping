import SwiftUI

struct RootView: View {

    @ObservedObject var appState: AppState 

    var body: some View {

        switch appState.state {

        case .idle:
            ProgressView()

        case .loggedOut:
            LoginView(appState: appState) 

        case .loggedIn:
            RootTabView()
        }
    }
}
