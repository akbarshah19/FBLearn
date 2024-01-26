//
//  AuthView.swift
//  STFirebaseBootcamp
//
//  Created by Akbarshah Jumanazarov on 1/17/24.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class AuthViewVM: ObservableObject {
    
    func signInGoogle() async throws {
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken: String = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: accessToken)
    }
}

struct AuthView: View {
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
