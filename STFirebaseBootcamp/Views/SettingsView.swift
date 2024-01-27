//
//  SettingsView.swift
//  STFirebaseBootcamp
//
//  Created by Akbarshah Jumanazarov on 1/18/24.
//

import SwiftUI

final class SettingsViewVM: ObservableObject {
    @Published var authProviders = [AuthProviderOption]()
    
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
}

struct SettingsView: View {
    @Binding var showSignInView: Bool
    @StateObject var vm = SettingsViewVM()
    
    var body: some View {
        List {
            if vm.authProviders.contains(.email) {
                Section {
                    Button {
                        Task {
                            do {
                                try await vm.updateEmail()
                                print("DEBUG ⚠️: Email updated!")
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Update Email")
                    }
                    
                    Button {
                        Task {
                            do {
                                try await vm.updatePassword()
                                print("DEBUG ⚠️: Password updated!")
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Update Password")
                    }
                    
                    Button {
                        Task {
                            do {
                                try await vm.resetPassword()
                                print("DEBUG ⚠️: Password reset!")
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Reset Password")
                    }
                } header: {
                    Text("Account")
                }
            }
            
            Button {
                Task {
                    do {
                        try vm.logOut()
                        showSignInView = true
                        print("DEBUG ⚠️: Logged out!")
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Log Out")
            }
        }
        .onAppear {
            vm.loadAuthProviders()
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationView {
        SettingsView(showSignInView: .constant(false))
    }
}
