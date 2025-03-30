//
//  Message.swift
//  app-pictlonis
//
//  Created by Quentin Vignan on 08/11/2022.
//

import Foundation

struct Message : Identifiable , Hashable {
    var id : String
    var text : String
    var username : String
    
    init(id: String, text: String, username: String) {
        self.id = id
        self.text = text
        self.username = username
    }
}
