//
//  User.swift
//  app-pictlonis
//
//  Created by Quentin Vignan on 08/11/2022.
//

import Foundation


struct User : Decodable {
    var email : String
    var password : String
    var username : String
    
    init(username: String, email: String, password: String) {
        self.email = email
        self.password = password
        self.username = username
    }
}
