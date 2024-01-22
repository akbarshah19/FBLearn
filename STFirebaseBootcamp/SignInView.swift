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
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        let result = try await AuthManager.shared.createUser(email: email,
                                                             password: password)
    }
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        let result = try await AuthManager.shared.signInUser(email: email,
                                                             password: password)
    }
}

struct SignInView: View {
    @StateObject var vm = SignInViewVM()
    @Binding var showSignInView: Bool
    
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
                Task {
                    do {
                        try await vm.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                    
                    do {
                        try await vm.signIn()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                }
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
        SignInView(showSignInView: .constant(false))
    }
}
