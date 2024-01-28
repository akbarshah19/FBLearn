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
        
        let authDataResult = try await AuthManager.shared.createUser(email: email,
                                                                     password: password)
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        let authDataResult = try await AuthManager.shared.signInUser(email: email,
                                                             password: password)
    }
}
