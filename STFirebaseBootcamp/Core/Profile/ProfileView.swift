//
//  ProfileView.swift
//  STFirebaseBootcamp
//
//  Created by Akbarshah Jumanazarov on 1/28/24.
//

import SwiftUI

@MainActor
final class ProfileViewVM: ObservableObject {
    @Published var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
}

struct ProfileView: View {
    @StateObject var vm = ProfileViewVM()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            if let user = vm.user {
                Text("UserID: \(user.userId)")
                
                if let isAnonymous = user.isAnonymous {
                    Text("Is Anonymous: \(isAnonymous.description.capitalized)")
                }
            }
        }
        .task {
            try? await vm.loadCurrentUser()
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }

            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}
