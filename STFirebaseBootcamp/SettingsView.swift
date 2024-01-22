//
//  SettingsView.swift
//  STFirebaseBootcamp
//
//  Created by Akbarshah Jumanazarov on 1/18/24.
//

import SwiftUI

final class SettingsViewVM: ObservableObject {
    
    func resetPassord() async throws {
        let authUser = try AuthManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthManager.shared.updatePassword(email: <#T##String#>)
    }
    
    func logOut() throws {
        try AuthManager.shared.signOut()
    }
    
    func updateEmail()  async throws {
        let email = "hello123@gmail.com"
        try await AuthManager.shared.updateEmail(email: email)
    }
    
    func updatePassword()  async throws {
        let password = "Hello123!"
        try await AuthManager.shared.updatePassword(password: <#T##String#>)
    }
}

struct SettingsView: View {
    @Binding var showSignInView: Bool
    @StateObject var vm = SettingsViewVM()
    
    var body: some View {
        List {
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
                        try await vm.resetPassord()
                        print("DEBUG ⚠️: Password reset!")
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Reset Password")
            }
            
            Button {
                Task {
                    do {
                        try vm.logOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Log Out")
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationView {
        SettingsView(showSignInView: .constant(false))
    }
}
