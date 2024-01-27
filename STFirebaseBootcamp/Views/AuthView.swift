//
//  AuthView.swift
//  STFirebaseBootcamp
//
//  Created by Akbarshah Jumanazarov on 1/17/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class AuthViewVM: ObservableObject {
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        try await AuthManager.shared.signInWithGoogle(tokens: tokens)
    }
}

struct AuthView: View {
    @StateObject var vm = AuthViewVM()
    @Binding var showSignInView: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    SignInView(showSignInView: $showSignInView)
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark,
                                                                          style: .wide,
                                                                          state: .normal)) {
                    Task {
                        do {
                            try await vm.signInGoogle()
                            showSignInView = false
                        } catch {
                            print(error)
                        }
                    }
                }

            }
            .padding()
            .navigationTitle("Sign In")
        }
    }
}

#Preview {
    NavigationView {
        AuthView(showSignInView: .constant(false))
    }
}
