//
//  SideMenuView.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import SwiftUI

struct SideMenuView: View {
    // MARK: - Properties
    @Environment(\.colorScheme) var scheme
    private let user: User
    
    private var headerTextColor: Color {
        return scheme == .light ? .white : .black
    }
    private var headerBackgroundColor: Color {
        return scheme == .light ? .black : .white
    }
    private var dividerColor: Color {
        return headerBackgroundColor
    }
    
    // MARK: - Init
    init(user: User) {
        self.user = user
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Header
            VStack(alignment: .leading, spacing: 0) {
                Button {
                    print("DEBUG: Handle navigate to user profile here..")
                } label: {
                    UberUserInfoView(user)
                        .padding()
                }
                
                Divider().background(dividerColor)
                
                Button {
                    print("DEBUG: Handle create business profile here..")
                } label: {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Do you Uber for business?")
                            .fontWeight(.semibold)
                        
                        Text("Tap to create your business profile")
                            .foregroundColor(.gray)
                    }
                    .frame(alignment: .leading)
                    .padding()
                }
            }
            .foregroundColor(.primary)
            .background(Color(.systemGray5))
            
            // MARK: - Side Menu Options
            VStack(alignment: .leading, spacing: 32) {
                ForEach(SideMenuOptionViewModel.allCases) { option in
                    NavigationLink(value: option) {
                        SideMenuOptionView(option)
                    }
                }
            }
            .navigationDestination(for: SideMenuOptionViewModel.self) { option in
                switch option {
                case .payment:
                    Text("Payment")
                case .trips:
                    Text("Trips")
                case .help:
                    Text("Help")
                case .settings:
                    SettingsView(user: user)
                }
            }
            .padding()
            
            Spacer()
        }
        .foregroundColor(headerTextColor)
        .background(headerBackgroundColor)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SideMenuView(
                user: User(
                    fullname: "Gunna Wunna",
                    email: "gunna@wunna.com",
                    uid: "123456"
                )
            )
        }
    }
}
