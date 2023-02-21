//
//  LoginView.swift
//  UberSwiftUI
//
//  Created by Maciej on 20/02/2023.
//

import SwiftUI

struct LoginView: View {
    // MARK: - Properties
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var authViewModel: AuthViewModel
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
        NavigationStack {
            VStack(spacing: 32) {
                // MARK: - Header
                Text("Uber").font(.system(size: 100))
                
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
                
                // MARK: - Password Reset
                Button {
                    print("DEBUG: Handle password reset here..")
                } label: {
                    Text("Forgot password?")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.trailing)
                
                // MARK: - Sign In
                UberWideButton(
                    "SIGN IN",
                    imageName: "arrow.right",
                    buttonTextColor: buttonTextColor,
                    buttonBackgroundColor: buttonBackgroundColor
                ) {
                    authViewModel.signIn(
                        email: email,
                        password: password
                    )
                }
                .padding(.horizontal)

                // MARK: - Sign In With Social
                VStack(spacing: 24) {
                    HStack {
                        Rectangle()
                            .frame(height: 2)
                            .frame(minWidth: 100)
                        
                        Text("Sign In with Social")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                        
                        Rectangle()
                            .frame(height: 2)
                            .frame(minWidth: 100)
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Social Buttons
                    HStack(spacing: 32) {
                        ForEach(SocialSignInType.allCases) { type in
                            UberSocialOptionButton(type: type) {
                                print("DEBUG: Handle Social Sign In here..")
                            }
                        }
                    }
                }
                
                Spacer()
                
                // MARK: - Don't Have An Account?
                NavigationLink {
                    RegistrationView()
                } label: {
                    UberBottomSignText(type: .signIn)
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
