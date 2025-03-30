//
//  AuthView.swift
//  app-pictlonis
//
//  Created by Quentin Vignan on 06/11/2022.
//

import Foundation
import SwiftUI


struct AuthView: View {
    @EnvironmentObject var presentedView: PresentedView
    @State var email = ""
    @State var password = ""
    @State var textError = ""
    @State var username = ""
    @State var AuthFunc = UserGest()
    @State var first = true
    var body: some View {
        VStack {
            Text("Pictlonis").padding().font(.system(size: 34).weight(.heavy))
            Text(textError).foregroundColor(.red)
            if (first) {
                TextField("Username", text: $username)
                    .textFieldStyle(GradientTextFieldBackground(systemImageString: "person"))
                    .padding()
            }
            TextField("Email", text: $email)
                .textFieldStyle(GradientTextFieldBackground(systemImageString: "envelope"))
                .padding()
            SecureField("Password", text: $password)
                .textFieldStyle(GradientTextFieldBackground(systemImageString: "lock"))
                .padding()
            VStack {
                Button(action: {
                    if (!first) {
                        Task {
                            if (AuthFunc.isValidEmail(email: email)) {
                                let resultCall = await AuthFunc.login(email: email , password: password)
                                if (resultCall) { presentedView.currentView = .room }
                                else { textError = "Erreur vérifier Mail/mot de passe" }
                            }
                            else {
                                textError = "l'email entrez n'est pas valide"
                            }
                        }
                    }
                    else {
                        
                        Task {
                            if (AuthFunc.isValidEmail(email: email)) {
                                let resultCall = await AuthFunc.register(username: username, email: email , password: password)
                                if (resultCall) { presentedView.currentView = .room }
                                else { textError = "Erreur vérifier Mail/mot de passe" }
                            }
                            else {
                                textError = "l'email entrez n'est pas valide"
                            }
                            
                        }
                    }
                }){
                    if (first) {
                        Text("register")
                    }
                    else {
                        Text("login")
                    }
                }.buttonStyle(BlueButton())
                Button(action: {
                    first = !first
                }){
                    if (first) {
                        Text("Vous avez déjà un compte ?")
                    }
                    else {
                        Text("Vous voulez créer un compte ?")
                    }
                }.buttonStyle(WarningButton())
            }
        }.onAppear(perform: {
            Task {
                let resultCall = await AuthFunc.login(email: UserDefaults.standard.string(forKey: "email")! , password: UserDefaults.standard.string(forKey: "password")!)
                if (resultCall) { presentedView.currentView = .room }
                else { AuthFunc.disconnect() }
            }
        })
    }
}
