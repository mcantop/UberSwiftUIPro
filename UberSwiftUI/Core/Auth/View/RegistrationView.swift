//
//  RegistrationView.swift
//  UberSwiftUI
//
//  Created by Maciej on 20/02/2023.
//

import SwiftUI

struct RegistrationView: View {
    // MARK: - Properties
    @Environment(\.colorScheme) var scheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var fullname = ""
    @State private var email = ""
    @State private var password = ""
    
    private var buttonTextColor: Color {
        return scheme == .light ? .white : .black
    }
    
    private var buttonBackgroundColor: Color {
        return scheme == .light ? .black : .white
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 32) {
            // MARK: - Header
            VStack(alignment: .leading, spacing: 16) {
                Text("Uber").font(.system(size: 100))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                
                Text("Create new account")
                    .fontWeight(.semibold)
            }
            .font(.largeTitle)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            // MARK: - Full Name
            VStack {
                UberTitleTextField(
                    "Full Name",
                    placeholder: "Enter your name",
                    text: $fullname
                )
                .padding(.horizontal)
                
                Divider()
            }
            
            // MARK: - Email
            VStack {
                UberTitleTextField(
                    "Email Address",
                    placeholder: "name@example.com",
                    text: $email
                )
                .padding(.horizontal)
                
                Divider()
            }
            
            // MARK: - Password
            VStack {
                UberTitleTextField(
                    "Password",
                    placeholder: "Enter your password",
                    isSecure: true,
                    text: $password
                )
                .padding(.horizontal)
                
                Divider()
            }
            
            // MARK: - Sign Up
            UberWideButton(
                "SIGN UP",
                imageName: "arrow.right",
                buttonTextColor: buttonTextColor,
                buttonBackgroundColor: buttonBackgroundColor
            ) {
                authViewModel.signUp(
                    fullname: fullname,
                    email: email,
                    password: password
                )
            }
            .padding(.horizontal)
            
            Spacer()
            
            // MARK: - Already Have An Account?
            Button {
                dismiss()
            } label: {
                UberBottomSignText(type: .signUp)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
