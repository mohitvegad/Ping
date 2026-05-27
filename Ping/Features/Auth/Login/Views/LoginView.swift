import SwiftUI

struct LoginView: View {

    @State private var name = ""
    @State private var phoneNumber = ""

    var body: some View {

        VStack(spacing: 25) {

//            Spacer()

            // Logo / Title
            VStack(spacing: 10) {

                Image(systemName: "message.fill")
                    .font(.system(size: 70))
                    .foregroundColor(.blue)

                Text("Ping")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Login with your details")
                    .foregroundColor(.gray)
            }

            // Input Fields
            VStack(spacing: 18) {

                TextField("Enter Name", text: $name)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                TextField("Enter Mobile Number", text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            // Login Button
            Button(action: {

                print("Name:", name)
                print("Phone:", phoneNumber)

                // Firebase login code here

            }) {

                Text("Continue")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(14)
            }
            .padding(.horizontal)
            .disabled(name.isEmpty || phoneNumber.isEmpty)
            .opacity(name.isEmpty || phoneNumber.isEmpty ? 0.6 : 1)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
