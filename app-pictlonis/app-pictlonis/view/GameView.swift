//
//  GameView.swift
//  app-pictlonis
//
//  Created by Quentin Vignan on 07/11/2022.
//

import Foundation
import SwiftUI


struct GameView: View {
    @EnvironmentObject var presentedView: PresentedView
    @ObservedObject var roomGest = RoomGest()
    @ObservedObject var msgGest = MsgGest()
    @State var textToSend = ""
    
    @State private var currentLine = Line()
    @State private var lines : [Line] = []
    @State private var newLines : [Line] = []
    @State private var thinkness = 2.5
    @State private var currentColor : Color = .black
    
    var body: some View {
        VStack {
            Spacer()
            /// part dessin
            VStack {
                Canvas { context , size in
                    for line in roomGest.drawList {
                        var path = Path()
                        path.addLines(line.points)
                        context.stroke(path, with: .color(line.color), lineWidth: line.lineWitdh)
                        
                    }
                }.gesture(DragGesture(minimumDistance: 0 , coordinateSpace: .local)
                    .onChanged({ value in
                        let newPoint = value.location
                        currentLine.lineWitdh = thinkness
                        currentLine.color = currentColor
                        currentLine.points.append(newPoint)
                        Task {
                            await roomGest.updateDraw(raw: currentLine)
                        }
                        newLines.append(currentLine)
                    })
                    .onEnded({ value in
                        self.currentLine = Line(points: [] , color: currentColor, lineWitdh: thinkness)
                    })
                )
            }.frame(minWidth: 350 , maxWidth: 350 , minHeight: 350 , maxHeight: 350)
                .background(Color.white)
                .border(.black)
            
            Slider(value: $thinkness,in: 1...10).frame(width: 150)
            /// par message
            
                
            
            List(msgGest.msgList, id: \.self) { raw in
                if (raw.username == UserDefaults.standard.string(forKey: "username")) {
                    CardSendStyle(username: raw.username, text: raw.text).listRowSeparator(.hidden)
                }
                else {
                    CardReveiveStyle(username: raw.username, text: raw.text).listRowSeparator(.hidden)
                }
                
            }.listStyle(GroupedListStyle())
                .scrollContentBackground(.hidden)
            TextField("text....", text: $textToSend)
                .textFieldStyle(GradientTextFieldBackground(systemImageString: "message"))
                .padding()
            HStack{
                Button(action: {
                    msgGest.sendMessage(text: textToSend)
                }){
                    Text("Envoyer")
                }.buttonStyle(BlueButton())
                Button(action: {
                    Task {
                        await roomGest.exitRoom()
                        presentedView.currentView = .room
                    }
                }){
                    Text("exit")
                }.buttonStyle(ExitButton())
            }
        }.onAppear(perform: {
            msgGest.observeMessage(roomID: UserDefaults.standard.string(forKey: "roomJoined")!)
            roomGest.observeDraw()
            print(UserDefaults.standard.string(forKey: "roomJoined")!)
        })
    }
}
