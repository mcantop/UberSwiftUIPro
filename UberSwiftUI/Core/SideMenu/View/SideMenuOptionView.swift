//
//  SideMenuOptionView.swift
//  UberSwiftUI
//
//  Created by Maciej on 21/02/2023.
//

import SwiftUI

struct SideMenuOptionView: View {
    // MARK: - Properties
    let option: SideMenuOptionViewModel
    
    // MARK: - Init
    init(_ option: SideMenuOptionViewModel) {
        self.option = option
    }
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: option.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 34)
                .fontWeight(.semibold)
            
            Text(option.title)
                .fontWeight(.medium)
        }
    }
}

struct SideMenuOptionMenu_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuOptionView(.trips)
    }
}
