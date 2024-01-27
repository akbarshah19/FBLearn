//
//  AuthManager.swift
//  STFirebaseBootcamp
//
//  Created by Akbarshah Jumanazarov on 1/17/24.
//

import Foundation
import FirebaseAuth

struct AuthModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
}

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    func getAuthenticatedUser() throws -> AuthModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthModel(user: user)
    }
    
    func getProvider() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
        return providers
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}

//MARK: - Sign in email
extension AuthManager {
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthModel {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthModel(user: authResult.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthModel {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthModel(user: authResult.user)
    }
    
    func updatePassword(email: String) async throws {
       try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updatePassword(to: password)
    }
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updateEmail(to: email)
    }
}

//MARK: - Sign in Google
extension AuthManager {
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthModel(user: authDataResult.user)
    }
}
