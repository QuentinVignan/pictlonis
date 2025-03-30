//
//  RoomGest.swift
//  app-pictlonis
//
//  Created by Quentin Vignan on 06/11/2022.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseDatabase



class RoomGest : ObservableObject {
    let db = Database.database(url: "http://localhost:9000/?ns=idv-mob4-c3d66-default-rtdb")
    @Published var allRoom : [RoomList] = []
    @Published var drawList : [Line] = []
    
    
    func toBase64(word: String) -> String{
        let base64Encoded = word.data(using: String.Encoding.utf8)!.base64EncodedString()
        return base64Encoded
    }
    
    func fromBase64(word: String)  -> String{
        let base64Decoded = Data(base64Encoded: word)!
        let decodedString = String(data: base64Decoded, encoding: .utf8)!
        return decodedString
    }

    func getAllRoom() async{
        var tmpArr : [RoomList] = []
        let ref = db.reference()
        ref.child("Rooms").observe(.value) { snapshot , error    in
            if let oSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for oSnap in oSnapshot {
                    let json = try? JSONSerialization.data(withJSONObject: oSnap.value as Any)
                    if let JSONString = String(data: json!, encoding: String.Encoding.utf8) {
                        let data = Data(JSONString.utf8)
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            let tmpRoom = RoomList(idRoom: oSnap.ref.key as Any as! String, roomName: json["roomName"] as Any as! String, countUser: json["countUser"] as Any as! Int, password: json["password"] as Any as! String)
                            tmpArr.append(tmpRoom)
                        }
                    }
                }
            }
            self.allRoom = tmpArr
            tmpArr = []
        }
    }
    
    
    func createRoom(name : String , password : String) async {
        let ref = db.reference()
        var tmpRoom : NSDictionary = [:]
        if (password == "None") {
            tmpRoom = [
                "roomName": name,
                "countUser": 1 ,
                "password": password ,
                "draw" : []
            ]
        }
        else {
            tmpRoom = [
                "roomName": name,
                "countUser": 1 ,
                "password": toBase64(word: password) ,
                "draw" : []
            ]
        }
        let _ = try? await ref.child("Rooms").childByAutoId().setValue(tmpRoom)
        
        let result = try? await ref.child("Rooms").getData()
        if let oSnapShot = result! .children.allObjects as? [DataSnapshot] {
            let count = oSnapShot.count
            let result = oSnapShot[count - 1].ref
            let keyResult = result.key
            UserDefaults.standard.set(keyResult, forKey: "roomCreated")
            UserDefaults.standard.set(keyResult, forKey: "roomJoined")
        }
    }
    
    func deleteRoom() async {
        let ref = db.reference()
        let _ = try? await ref.child("Rooms").child(UserDefaults.standard.string(forKey: "roomCreated")!).removeValue()
        UserDefaults.standard.set("", forKey: "roomCreated")
        UserDefaults.standard.set("", forKey: "roomJoined")
    }
    
    func joinRoom(roomID : String) async {
        let ref = db.reference()
        let result = try? await ref.child("Rooms").getData()
        if let oSnapShot = result! .children.allObjects as? [DataSnapshot] {
            for oSnap in oSnapShot {
                if (oSnap.ref.key == roomID) {
                    let json = try? JSONSerialization.data(withJSONObject: oSnap.value as Any)
                    if let JSONString = String(data: json!, encoding: String.Encoding.utf8) {
                        let data = Data(JSONString.utf8)
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print(roomID)
                            UserDefaults.standard.set(roomID , forKey: "roomJoined")
                            UserDefaults.standard.set("", forKey: "roomCreated")
                            let countUserTotal = (json["countUser"] as? Int)! + 1
                            let tmpRoom : NSDictionary = [
                                "countUser": countUserTotal
                            ]
                            let _ = try? await ref.child("Rooms").child(roomID).updateChildValues(tmpRoom as! [AnyHashable : Any])
                        }
                    }
                }
            }
        }
    
    }
    
    func exitRoom() async {
        UserDefaults.standard.set("", forKey: "roomCreated")
        UserDefaults.standard.set("", forKey: "roomJoined")
        let ref = db.reference()
        let result = try? await ref.child("Rooms").getData()
        if let oSnapShot = result! .children.allObjects as? [DataSnapshot] {
            for oSnap in oSnapShot {
                if (oSnap.ref.key == UserDefaults.standard.string(forKey: "roomJoined")) {
                    let json = try? JSONSerialization.data(withJSONObject: oSnap.value as Any)
                    if let JSONString = String(data: json!, encoding: String.Encoding.utf8) {
                        let data = Data(JSONString.utf8)
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            let countUserTotal = (json["countUser"] as? Int)! - 1
                            let tmpRoom : NSDictionary = [
                                "countUser": countUserTotal
                            ]
                            let _ = try? await ref.child("Rooms").child(UserDefaults.standard.string(forKey: "roomJoined")!).updateChildValues(tmpRoom as! [AnyHashable : Any])
                        }
                    }
                }
            }
        }
        UserDefaults.standard.set("", forKey: "roomCreated")
        UserDefaults.standard.set("", forKey: "roomJoined")
    }
    
    func checkRoomExist(roomID : String) async -> Bool {
        var check = false
        let ref = db.reference()
        let result = try? await ref.child("Rooms").getData()
        if let oSnapShot = result! .children.allObjects as? [DataSnapshot] {
            for oSnap in oSnapShot {
                if (oSnap.ref.key == roomID) {
                    check = true
                }
            }
        }
        return check
    }
    
    func observeDraw() {
        let ref = db.reference()
        var tmpDrawList : [Line] = []
        ref.child("Rooms").child(UserDefaults.standard.string(forKey: "roomJoined")!).child("draw").observe(.value) { snapshot , error    in
            if let oSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for oSnap in oSnapshot {
                    let dict = oSnap.value as! NSDictionary
                    let str = dict["points"] as! String
                    var listOfPoints : [CGPoint] = []
                    let tmpPoints = str.components(separatedBy: "###")
                    for point in tmpPoints {
                        if (point != "") {
                            let tmpArr = point.components(separatedBy: "/")
                            let xString = tmpArr[0]
                            let yString = tmpArr[1]
                            let doubleX = Double(xString)
                            let doubleY = Double(yString)
                            let tmpCgpoint = CGPoint(x: doubleX! , y: doubleY!)
                            listOfPoints.append(tmpCgpoint)
                        }
                    }
                    let tmpLineWithdh = dict["lineWitdh"] as! String
                    let doubleWitdh = Double(tmpLineWithdh)
                    
                    let tmpLine : Line = Line(points: listOfPoints , color: Color.black , lineWitdh: doubleWitdh!)
                    tmpDrawList.append(tmpLine)
                    
                }
                self.drawList = tmpDrawList
                tmpDrawList = []
            }
        }
    }
    
    func updateDraw(raw: Line) async {
        let ref = db.reference()
        var tmpLines : NSMutableDictionary = [:]
        var str = ""
        for rawPoints in raw.points {
            let pointStr = "" + rawPoints.x.description + "/" + rawPoints.y.description
            str +=  pointStr + "###"
        }
        tmpLines.setValue(str , forKey: "points")
        tmpLines.setValue(raw.color.description, forKey: "color")
        
        tmpLines.setValue(raw.lineWitdh.description, forKey: "lineWitdh")
        let _ = try? await ref.child("Rooms").child(UserDefaults.standard.string(forKey: "roomJoined")!).child("draw").childByAutoId().setValue(tmpLines as NSDictionary)
    }
}

