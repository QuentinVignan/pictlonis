//
//  MsgGest.swift
//  app-pictlonis
//
//  Created by Quentin Vignan on 07/11/2022.
//

import Foundation
import FirebaseDatabase
import Firebase


class MsgGest : ObservableObject {
    let db = Database.database(url: "http://localhost:9000/?ns=idv-mob4-c3d66-default-rtdb")
    @Published var msgList : [Message] = []
    
    func sendMessage(text : String) {
        let ref = db.reference()
        let msg : NSDictionary = [
            "text" : text,
            "username" : UserDefaults.standard.string(forKey: "username")! ,
            "id" : UserDefaults.standard.string(forKey: "roomJoined")!
        ]
        ref.child("message").childByAutoId().setValue(msg)
    }
    
    func observeMessage(roomID : String) {
        let ref = db.reference()
        var tmpMsgList : [Message] = []
        ref.child("message").observe(.value) { snapshot , error    in
            if let oSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for oSnap in oSnapshot {
                    let dict = oSnap.value as! NSDictionary
                    if (dict["id"] as! String == roomID) {
                        let tmpMsg = Message(id: dict["id"] as! String, text: dict["text"] as! String, username: dict["username"] as! String)
                        tmpMsgList.append(tmpMsg)
                    }
                }
            }
    
            self.msgList = tmpMsgList
            tmpMsgList = []
        }
    }
    
    
}
