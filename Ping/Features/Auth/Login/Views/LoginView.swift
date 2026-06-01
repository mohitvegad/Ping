import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel: LoginViewModel
    var appState: AppState
    
    init(appState: AppState) {
        
        self.appState = appState
        
        let service = FirebaseAuthService()
        let repo = AuthRepository(authService: service)
        
        _viewModel = StateObject(
            wrappedValue: LoginViewModel(
                appState: appState,
                repository: repo
            )
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
            
            // MARK: - STATE UI
            
            switch viewModel.state {
                
            case .idle:
                EmptyView()
                
            case .loading:
                ProgressView()
                    .tint(.white)
                
            case .success(let uid):
                Text("Login Success")
                    .foregroundColor(.green)
                
            case .error(let message):
                Text(message)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            // BUTTON
            Button {
                viewModel.login()
            } label: {
                
                Text("Login")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
            .disabled(viewModel.state == .loading ||
                      viewModel.email.isEmpty ||
                      viewModel.password.isEmpty)
            
            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    //    LoginView()
}
