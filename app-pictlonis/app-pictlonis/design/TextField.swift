//
//  TextField.swift
//  app-pictlonis
//
//  Created by Quentin Vignan on 08/11/2022.
//

import Foundation
import SwiftUI

struct GradientTextFieldBackground: TextFieldStyle {
    
    let systemImageString: String

    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(
                    LinearGradient(
                        colors: [
                            .red,
                            .blue
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 40)
            
            HStack {
                Image(systemName: systemImageString)
                configuration
            }
            .padding(.leading)
            .foregroundColor(.gray)
        }
    }
}
