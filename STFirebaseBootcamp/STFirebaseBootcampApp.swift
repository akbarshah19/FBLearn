//
//  STFirebaseBootcampApp.swift
//  STFirebaseBootcamp
//
//  Created by Akbarshah Jumanazarov on 1/1/24.
//

import SwiftUI
import Firebase

@main
struct STFirebaseBootcampApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
