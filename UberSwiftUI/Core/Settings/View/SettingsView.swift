//
//  SettingsView.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - Properties
    @EnvironmentObject var authViewModel: AuthViewModel
    let user: User
    
    // MARK: - Body
    var body: some View {
        VStack {
            List {
                Section {
                    // TODO: Add chevron to navigation.
                    UberUserInfoView(user)
                }
                
                Section("Favorites") {
                    ForEach(FavoriteLocationViewModel.allCases) { viewModel in
                        NavigationLink {
                            FavoriteLocationSearchView(config: viewModel)
                                .navigationTitle("Add \(viewModel.title)")
                        } label: {
                            FavoriteLocationRowView(viewModel, user: user)
                        }
                    }
                }
                
                Section("App") {

                }
                
                Section("Account") {
                    SettingsRowView(
                        name: "Make Money Driving",
                        imageName: "dollarsign.circle.fill"
                    )
                    
                    Button {
                        authViewModel.signOut()
                    } label: {
                        SettingsRowView(
                            name: "Sign Out",
                            imageName: "arrow.left.circle.fill"
                        )
                    }

                    
                    SettingsRowView(
                        name: "Delete Account",
                        imageName: "trash.circle.fill"
                    )
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(user: dev.mockUser)
            .environmentObject(AuthViewModel())
        }
    }
}
