//
//  SettingsView.swift
//  STFirebaseBootcamp
//
//  Created by Akbarshah Jumanazarov on 1/18/24.
//

import SwiftUI

final class SettingsViewVM: ObservableObject {
    
    func logOut() throws {
        try AuthManager.shared.signOut()
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
