//
//  SignInView.swift
//  STFirebaseBootcamp
//
//  Created by Akbarshah Jumanazarov on 1/17/24.
//

import SwiftUI

@MainActor
final class SignInViewVM: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        Task {
            do {
                let result = try await AuthManager.shared.createUser(email: email, password: password)
                print("DEBUG ⚠️: AuthResult - ", result)
            } catch {
                print(error)
            }
        }
    }
}

struct SignInView: View {
    @StateObject var vm = SignInViewVM()
    
    var body: some View {
        VStack {
            TextField("Email", text: $vm.email)
                .padding()
                .background(Color.blue.opacity(0.3))
                .cornerRadius(10)
            
            SecureField("Password", text: $vm.password)
                .padding()
                .background(Color.blue.opacity(0.3))
                .cornerRadius(10)
            
            Button {
                vm.signIn()
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

#Preview {
    NavigationView {
        SignInView()
    }
}
