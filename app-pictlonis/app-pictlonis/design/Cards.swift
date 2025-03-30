//
//  Cards.swift
//  app-pictlonis
//
//  Created by Quentin Vignan on 09/11/2022.
//

import Foundation
import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.white.opacity(0.2), radius: 20, x: 0, y: 0)
    }
}

struct CardModifierMSG: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(6)
            .shadow(color: Color.white.opacity(0.2), radius: 20, x: 0, y: 0)
    }
}

struct CardStyle: View {
    
    var nameOfRoom: String
    var password : String
    var NbUser: Int
    
    
    var body: some View {
        HStack(alignment: .center) {
            if (password == "None") {
                Image(systemName: "lock.open")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25)
                    .padding(.all, 20)
            }
            else {
                Image(systemName: "lock")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 26)
                    .padding()
            }
            
            VStack() {
                VStack {
                    Text(nameOfRoom)
                        .font(.system(size: 26, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    HStack {
                        Text("Nb de joueur : " + String(NbUser))
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .foregroundColor(.white)
                    }
                }
            }.padding(.trailing, 20)
            Spacer()
        }
        .frame(maxWidth: 400, maxHeight: 200,  alignment: .center)
        .background(Color.gray)
        .modifier(CardModifier())
        .padding(.all, 10)
    }
}


struct CardReveiveStyle: View {
    var username: String
    var text : String
    var body: some View {
        HStack(alignment: .center) {
            VStack() {
                VStack {
                    Text(username)
                        .font(.system(size: 10, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    HStack {
                        Text(text)
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .foregroundColor(.white)
                    }
                }
            }.padding(.trailing, 20)
        }
        .frame(maxWidth: 400, maxHeight: 150,  alignment: .center)
        .background(Color.gray)
        .modifier(CardModifier())
        .padding(.all, 10)
    }
}


struct CardSendStyle: View {
    var username: String
    var text : String
    var body: some View {
        HStack(alignment: .center) {
            VStack() {
                VStack {
                    Text(username)
                        .font(.system(size: 10, weight: .bold, design: .default))
                        .foregroundColor(.black)
                    HStack {
                        Text(text)
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .foregroundColor(.white)
                    }
                }
            }.padding(.trailing, 20)
        }
        .frame(maxWidth: 400, maxHeight: 150,  alignment: .center)
        .background(Color.blue)
        .modifier(CardModifierMSG())
        .padding(.all, 10)
    }
}
