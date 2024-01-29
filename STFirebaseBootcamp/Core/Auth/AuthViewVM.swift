//
//  AuthViewVM.swift
//  STFirebaseBootcamp
//
//  Created by Akbarshah Jumanazarov on 1/28/24.
//

import Foundation

@MainActor
final class AuthViewVM: ObservableObject {
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let res = try await AuthManager.shared.signInWithGoogle(tokens: tokens)
        let user = DBUser(auth: res)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func signInAnonymous() async throws {
        let res = try await AuthManager.shared.signInAnonymous()
        let user = DBUser(auth: res)
        try await UserManager.shared.createNewUser(user: user)
    }
}
