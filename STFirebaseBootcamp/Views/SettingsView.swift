//
//  SettingsView.swift
//  STFirebaseBootcamp
//
//  Created by Akbarshah Jumanazarov on 1/18/24.
//

import SwiftUI

@MainActor
final class SettingsViewVM: ObservableObject {
    @Published var authProviders = [AuthProviderOption]()
    @Published var authUser: AuthModel? = nil
    
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

struct SettingsView: View {
    @Binding var showSignInView: Bool
    @StateObject var vm = SettingsViewVM()
    
    var body: some View {
        List {
            if vm.authProviders.contains(.email) {
                Section {
                    Button("Update Email") {
                        Task {
                            do {
                                try await vm.updateEmail()
                                print("DEBUG ⚠️: Email updated!")
                            } catch {
                                print(error)
                            }
                        }
                    }
                    
                    Button("Update Password") {
                        Task {
                            do {
                                try await vm.updatePassword()
                                print("DEBUG ⚠️: Password updated!")
                            } catch {
                                print(error)
                            }
                        }
                    }
                    
                    Button("Reset Password") {
                        Task {
                            do {
                                try await vm.resetPassword()
                                print("DEBUG ⚠️: Password reset!")
                            } catch {
                                print(error)
                            }
                        }
                    }
                } header: {
                    Text("Account")
                }
            }
            
            if vm.authUser?.isAnonymous == true {
                Section {
                    Button("Link Email") {
                        Task {
                            do {
                                try await vm.linkEmailAccount()
                                print("DEBUG ⚠️: Email linked!")
                            } catch {
                                print(error)
                            }
                        }
                    }
                    
                    Button("Link Google Account") {
                        Task {
                            do {
                                try await vm.linkGoogleAccount()
                                print("DEBUG ⚠️: Google Acc linked!")
                            } catch {
                                print(error)
                            }
                        }
                    }
                } header: {
                    Text("Create account")
                }
            }
            
            Button("Log Out") {
                Task {
                    do {
                        try vm.logOut()
                        showSignInView = true
                        print("DEBUG ⚠️: Logged out!")
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button(role: .destructive) {
                Task {
                    do {
                        try await vm.deleteAccount()
                        showSignInView = true
                        print("DEBUG ⚠️: Logged out!")
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Delete Account")
            }

        }
        .onAppear {
            vm.loadAuthProviders()
            vm.loadAuthUser()
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationView {
        SettingsView(showSignInView: .constant(false))
    }
}
