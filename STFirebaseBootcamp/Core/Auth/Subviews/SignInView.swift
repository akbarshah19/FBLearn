//
//  SignInView.swift
//  STFirebaseBootcamp
//
//  Created by Akbarshah Jumanazarov on 1/17/24.
//

import SwiftUI

struct SignInView: View {
    @StateObject var vm = SignInViewVM()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            TextField("Email", text: $vm.email)
                .padding()
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .background(Color.blue.opacity(0.3))
                .cornerRadius(10)
            
            SecureField("Password", text: $vm.password)
                .padding()
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .background(Color.blue.opacity(0.3))
                .cornerRadius(10)
            
            Button {
                Task {
                    do {
                        try await vm.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                    
                    do {
                        try await vm.signIn()
                        showSignInView = false
                        return
                    } catch {
                        print(error)
                    }
                }
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

#Preview {
    NavigationView {
        SignInView(showSignInView: .constant(false))
    }
}
