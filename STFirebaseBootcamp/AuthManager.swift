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

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    func getAuthenticatedUser() throws -> AuthModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthModel(user: user)
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
    
}
