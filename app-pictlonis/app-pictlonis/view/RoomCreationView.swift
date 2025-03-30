//
//  RoomCreationView.swift
//  app-pictlonis
//
//  Created by Quentin Vignan on 08/11/2022.
//

import Foundation
import SwiftUI

struct RoomCreationView: View {
    @EnvironmentObject var presentedView: PresentedView
    @ObservedObject var roomGest = RoomGest()
    @State var nameOfRoom = ""
    @State var password = ""
    var body: some View {
        VStack {
            VStack {
                Text("Creation de la room").padding().font(.system(size: 34).weight(.heavy))
                TextField("Nom de la room", text: $nameOfRoom)
                    .textFieldStyle(GradientTextFieldBackground(systemImageString: "person"))
                    .padding()
                Text("Laissez vide si public").padding().font(.system(size: 12).weight(.heavy))
                SecureField("Mot de passe de la room", text: $password)
                    .textFieldStyle(GradientTextFieldBackground(systemImageString: "lock"))
                    .padding()
                VStack {
                    Button(action: {
                        Task {
                            if (password == "") {
                                await roomGest.createRoom(name: nameOfRoom , password: "None")
                            }
                            else {
                                await roomGest.createRoom(name: nameOfRoom , password: password)
                            }
                            presentedView.currentView = .inGame
                        }
                    }){
                        Text("Créer la room")
                    }.buttonStyle(BlueButton())
                }
            }
        }
    }
}
