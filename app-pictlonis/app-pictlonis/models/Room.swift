//
//  Room.swift
//  app-pictlonis
//
//  Created by Quentin Vignan on 08/11/2022.
//

import Foundation

struct Room {
    var roomName : String
    var countUser : Int
    var draw: [Line]
    var password : String
    
    init(roomName: String, countUser: Int,password: String ,draw: [Line]) {
        self.roomName = roomName
        self.countUser = countUser
        self.draw = draw
        self.password = password
    }
}

struct RoomList : Identifiable{
    var id : String
    var roomName : String
    var countUser : Int
    var password : String
    
    init(idRoom: String, roomName: String, countUser: Int , password: String) {
        self.id = idRoom
        self.roomName = roomName
        self.countUser = countUser
        self.password = password
    }
}
