//
//  ContentView.swift
//  app-pictlonis
//
//  Created by Quentin Vignan on 05/11/2022.
//

import SwiftUI

class PresentedView: ObservableObject {
    enum AvailableViews {
        case auth , room , inGame , roomCreation
    }
    @Published var currentView: AvailableViews = .auth
}


struct ContentView: View {
    @EnvironmentObject var presentedView: PresentedView
        var body: some View {
            switch presentedView.currentView {
                case .auth: AuthView()
                case .room: RoomView()
                case .inGame: GameView()
                case .roomCreation: RoomCreationView()
            }
        }
}


