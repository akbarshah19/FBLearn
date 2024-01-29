//
//  SignInViewVM.swift
//  STFirebaseBootcamp
//
//  Created by Akbarshah Jumanazarov on 1/28/24.
//

import Foundation

@MainActor
final class SignInViewVM: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        let res = try await AuthManager.shared.createUser(email: email, password: password)
        let user = DBUser(auth: res)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        let _ = try await AuthManager.shared.signInUser(email: email, password: password)
    }
}
