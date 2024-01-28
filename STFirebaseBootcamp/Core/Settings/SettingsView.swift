//
//  SettingsView.swift
//  STFirebaseBootcamp
//
//  Created by Akbarshah Jumanazarov on 1/18/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showSignInView: Bool
    @StateObject var vm = SettingsViewVM()
    
    var body: some View {
        List {
            if vm.authProviders.contains(.email) {
                EmailOptionButtons()
            }
            
            if vm.authUser?.isAnonymous == true {
                AnonymousUserButtons()
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
    
    @ViewBuilder func EmailOptionButtons() -> some View {
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
    
    @ViewBuilder func AnonymousUserButtons() -> some View {
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
}

#Preview {
    NavigationView {
        SettingsView(showSignInView: .constant(false))
    }
}
