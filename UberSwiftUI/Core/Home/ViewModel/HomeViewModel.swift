//
//  HomeViewModel.swift
//  UberSwiftUI
//
//  Created by Maciej on 25/02/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import Combine

final class HomeViewModel: ObservableObject {
    // MARK: - Properties
    @Published var drivers = [User]()
    private let userService = UserSerivce.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        fetchUser()
    }
}

// MARK: - Helpers
extension HomeViewModel {
    func fetchDrivers() {
        Firestore.firestore().collection("users")
            .whereField("accountType", isEqualTo: AccountType.driver.rawValue)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let drivers = documents.compactMap({ try?  $0.data(as: User.self) })
                self.drivers = drivers                
            }
    }
    
    func fetchUser() {
        userService.$user
            .sink { user in
                guard let user = user else { return }
                guard user.accountType == .passenger else { return }
                self.fetchDrivers()
            }
            .store(in: &cancellables)
    }
}
