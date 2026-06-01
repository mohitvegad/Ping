import SwiftUI

struct LoginView: View {

    @StateObject private var viewModel: LoginViewModel

    init() {
        let service = FirebaseAuthService()
        let repo = AuthRepository(authService: service)

        _viewModel = StateObject(
            wrappedValue: LoginViewModel(repository: repo)
        )
    }

    var body: some View {

        VStack(spacing: 20) {

            Spacer()

            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            // EMAIL
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.horizontal)

            // PASSWORD
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.horizontal)

            // ERROR
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            // BUTTON
            Button {

                viewModel.login()

            } label: {

                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text("Login")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
            .disabled(viewModel.email.isEmpty ||
                      viewModel.password.isEmpty ||
                      viewModel.isLoading)

            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    LoginView()
}
