//
//  SettingsVM.swift
//  STFirebaseBootcamp
//
//  Created by Akbarshah Jumanazarov on 1/28/24.
//

import Foundation

@MainActor
final class SettingsViewVM: ObservableObject {
    @Published var authProviders = [AuthProviderOption]()
    @Published var authUser: AuthDataResultModel? = nil
    
    func loadAuthUser() {
        self.authUser = try? AuthManager.shared.getAuthenticatedUser()
    }
    
    func loadAuthProviders() {
        if let providers = try? AuthManager.shared.getProvider() {
            authProviders = providers
        }
    }
    
    func resetPassword() async throws {
        let authUser = try AuthManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthManager.shared.updatePassword(email: email)
    }
    
    func deleteAccount() async throws {
        try await AuthManager.shared.deleteUser()
    }
    
    func logOut() throws {
        try AuthManager.shared.signOut()
    }
    
    func updateEmail()  async throws {
        let email = "admin@admin2.com"
        try await AuthManager.shared.updateEmail(email: email)
    }
    
    func updatePassword()  async throws {
        let password = "adminadmin2"
        try await AuthManager.shared.updatePassword(password: password)
    }
    
    func linkGoogleAccount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        authUser = try await AuthManager.shared.linkGoogle(tokens: tokens)
    }
    
    func linkEmailAccount() async throws {
        let email = "admin@admin.com"
        let password = "adminadmin"
        authUser = try await AuthManager.shared.linkEmail(email: email,
                                                          password: password)
    }
}
