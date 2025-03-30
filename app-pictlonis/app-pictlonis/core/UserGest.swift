//
//  UserGest.swift
//  app-pictlonis
//
//  Created by Quentin Vignan on 06/11/2022.
//

import Foundation
import FirebaseDatabase
import Firebase
import CryptoKit

class UserGest: NSObject {
    let db = Database.database(url: "http://localhost:9000/?ns=idv-mob4-c3d66-default-rtdb")
    
    
    func toBase64(word: String) -> String{
        let base64Encoded = word.data(using: String.Encoding.utf8)!.base64EncodedString()
        return base64Encoded
    }
    
    func fromBase64(word: String)  -> String{
        let base64Decoded = Data(base64Encoded: word)!
        let decodedString = String(data: base64Decoded, encoding: .utf8)!
        return decodedString
    }
    
    func login(email: String = "none" , password: String  = "none" ) async -> Bool {
        let ref = db.reference()
        var tmpArr: [User] = []
        var check = false
        let result = try? await ref.child("Users").getData()
        if let oSnapShot = result!.children.allObjects as? [DataSnapshot] {
            for oSnap in oSnapShot {
                let json = try? JSONSerialization.data(withJSONObject: oSnap.value as Any)
                if let JSONString = String(data: json!, encoding: String.Encoding.utf8) {
                    let data = Data(JSONString.utf8)
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        var usertmp = User(username: "", email: "", password: "")
                        usertmp.username = json["username"] as! String
                        usertmp.email = json["email"]  as! String
                        usertmp.password = json["password"] as! String
                        tmpArr.append(usertmp)
                    }
                }
            }
        }
        print(tmpArr.count)
        for raw in tmpArr {
            print(raw)
            print(email)
            print(password)
            if (raw.email == email) {
                if (raw.password == toBase64(word: password)) {
                    UserDefaults.standard.set(raw.email, forKey: "email")
                    UserDefaults.standard.set(raw.password, forKey: "password")
                    UserDefaults.standard.set(raw.username, forKey: "username")
                    check = true
                }
            }
        }
        return check
        
    }
    
    func register(username: String , email: String , password: String) async -> Bool {
        let tmpUser : NSDictionary = [
            "username": username,
            "email": email ,
            "password": toBase64(word: password)
        ]
        let ref = db.reference()
        let _ = try? await ref.child("Users").childByAutoId().setValue(tmpUser)
        let result = await login(email: email , password: password)
        return result
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func disconnect() {
        UserDefaults.standard.set("", forKey: "email")
        UserDefaults.standard.set("", forKey: "password")
        UserDefaults.standard.set("", forKey: "username")
    }
}

