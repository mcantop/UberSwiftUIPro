//
//  AuthViewModel.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

final class AuthViewModel: ObservableObject {
    // MARK: - Properties
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    private let userService = UserSerivce.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        userSession = Auth.auth().currentUser
        fetchUser()
    }
}

// MARK: - Public Helpers
extension AuthViewModel {
    func signUp(fullname: String, email: String, password: String) {
        guard let location = LocationManager.shared.userLocation else { return }
        print("DEBUG: Location is \(location)")
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to Sign Up with error - \(error.localizedDescription)")
                return
            }

            self.userSession = result?.user

            print("DEBUG: Authenticated a new user successfully.")

            guard let firebaseUser = result?.user else { return }
            let user = User(
                fullname: fullname,
                email: email,
                uid: firebaseUser.uid,
                coordinates: GeoPoint(latitude: location.latitude, longitude: location.longitude),
                accountType: .driver
            )

            guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
            Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encodedUser)
            self.currentUser = user

            print("DEBUG: Sent a new user data to database successfully.")
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to Sign In with error - \(error.localizedDescription)")
                return
            }
            
            self.userSession = result?.user
            self.fetchUser()

            print("DEBUG: Signed In user successfully.")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            print("DEBUG: Signed Out user successfully.")
        } catch let error {
            print("DEBUG: Failed to Sign Out with error - \(error.localizedDescription)")
        }
    }
    
    func fetchUser() {
        userService.$user
            .sink { user in
                self.currentUser = user
            }
            .store(in: &cancellables)
    }
}
