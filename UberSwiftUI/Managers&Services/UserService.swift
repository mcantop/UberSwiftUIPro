//
//  UserService.swift
//  UberSwiftUI
//
//  Created by Maciej on 04/03/2023.
//

import Foundation
import Firebase

final class UserSerivce: ObservableObject {
    static let shared = UserSerivce()
    @Published var user: User?
    
    init() {
        fetchUser()
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            guard let user = try? snapshot.data(as: User.self) else { return }
            self.user = user

            print("DEBUG: User fetching successful..")
        }
    }
}
