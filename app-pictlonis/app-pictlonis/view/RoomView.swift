//
//  RoomView.swift
//  app-pictlonis
//
//  Created by Quentin Vignan on 06/11/2022.
//

import Foundation
import SwiftUI

struct RoomView: View {
    
    func toBase64(word: String) -> String{
        let base64Encoded = word.data(using: String.Encoding.utf8)!.base64EncodedString()
        return base64Encoded
    }
    
    func fromBase64(word: String)  -> String{
        let base64Decoded = Data(base64Encoded: word)!
        let decodedString = String(data: base64Decoded, encoding: .utf8)!
        return decodedString
    }
    
    @EnvironmentObject var presentedView: PresentedView
    @ObservedObject var roomGest = RoomGest()
    @State var AuthFire = UserGest()
    @State var showingAlert = false
    @State var neededPassword = ""
    @State var password = ""
    @State var idRoom = ""
    var body: some View {
        VStack {
            List {
                ForEach(roomGest.allRoom) { raw in
                    CardStyle(nameOfRoom: raw.roomName, password: raw.password , NbUser: 1)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if (raw.password == "None") {
                                Task {
                                    await roomGest.joinRoom(roomID: raw.id)
                                    presentedView.currentView = .inGame
                                }
                            }
                            else {
                                idRoom = raw.id
                                password = raw.password
                                showingAlert = true
                            }
                        }
                }.listRowSeparator(.hidden)
                    .alert("mot de passe demander",isPresented: $showingAlert, actions: {
                        SecureField("Mot de passe de la room", text: $neededPassword)
                            .textFieldStyle(GradientTextFieldBackground(systemImageString: "lock"))
                            .padding()
                        Button("Envoyer" , action: {
                            if (password == toBase64(word: neededPassword)) {
                                Task {
                                    await roomGest.joinRoom(roomID: idRoom)
                                    presentedView.currentView = .inGame
                                }
                            }
                            else {
                                showingAlert = false
                            }
                        })
                    })
            }.listStyle(GroupedListStyle())
                .scrollContentBackground(.hidden)
            
            HStack {
                Button(action: {
                    presentedView.currentView = .roomCreation
                }){
                    Text("Créer")
                }.buttonStyle(BlueButton())
                Button(action: {
                    Task {
                        AuthFire.disconnect()
                        presentedView.currentView = .auth
                    }
                }){
                    Text("Déconnection")
                }.buttonStyle(ExitButton())
            }
        }.onAppear(perform : {
            Task {
                await roomGest.getAllRoom()
            }
        })
    }
}
