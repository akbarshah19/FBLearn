//
//  FirestoreManager.swift
//  STFirebaseBootcamp
//
//  Created by Akbarshah Jumanazarov on 1/28/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct DBUser {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
}

final class UserManager {
    static let shared = UserManager()
    let db = Firestore.firestore()
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData: [String : Any] = [
            "user_id" : auth.uid,
            "is_anonymous" : auth.isAnonymous,
            "date_created" : Timestamp()
        ]
        
        if let email = auth.email {
            userData["email"] = email
        }
        
        if let url = auth.photoUrl {
            userData["photo_url"] = url
        }
        
        try await db.collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await db.collection("users").document(userId).getDocument()
        guard let data = snapshot.data(),
              let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let isAnonymous = data["is_anonymous"] as? Bool
        let email = data["email"] as? String
        let photoUrl = data["photo_url"] as? String
        let dateCreated = data["date_created"] as? Date
        
        return DBUser(userId: userId,
                      isAnonymous: isAnonymous,
                      email: email,
                      photoUrl: photoUrl,
                      dateCreated: dateCreated)
    }
}