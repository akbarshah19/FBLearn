//
//  AuthView.swift
//  STFirebaseBootcamp
//
//  Created by Akbarshah Jumanazarov on 1/17/24.
//

import SwiftUI

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
