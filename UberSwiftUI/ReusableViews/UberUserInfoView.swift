//
//  UberUserInfoView.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import SwiftUI

struct UberUserInfoView: View {
    // MARK: - Properties
    let user: User
    
    // MARK: - Init
    init(_ user: User) {
        self.user = user
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 16) {
            Image("Future")
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 64, height: 64)
            
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                Text(user.fullname)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(verbatim: user.email)
                    .font(.subheadline)
                    .fontWeight(.light)
                
                Spacer()
            }
            
            Spacer()
        }
        .frame(height: 64)
    }
}

struct UberUserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UberUserInfoView(dev.mockUser)
    }
}
