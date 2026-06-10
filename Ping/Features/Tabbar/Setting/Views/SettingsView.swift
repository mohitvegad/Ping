import SwiftUI

struct SettingsView: View {

    @ObservedObject var appSession: AppSession

    var body: some View {
        VStack {
            Spacer()

            Button {
                appSession.logout()
            } label: {
                Text("Log Out")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

