//
//  SocketIOManager.swift
//  BilkentHackathon_iOS
//
//  Created by Mansur Muaz Ekici on 23.02.2019.
//  Copyright © 2019 mmuazekici. All rights reserved.
//

import UIKit
import SocketIO
import SwiftyJSON

enum Namespace {
    case quiz
    case networking
}

struct LoginData : SocketData {
    let deviceID: String
    let categories: [Int]
    
    func socketRepresentation() -> SocketData {
        return ["phoneId": deviceID, "categories": categories]
    }
}

struct ChoiceData : SocketData {
    let choice: Int
    
    func socketRepresentation() -> SocketData {
        return ["choice": choice]
    }
}

class SocketIOManager: NSObject {

    static let sharedInstance = SocketIOManager()
    
    static let manager = SocketManager(socketURL: URL(string: "http://104.248.131.83:8080")!, config: [.log(true), .compress])
    
    static var socket = SocketIOManager.manager.defaultSocket
    
    func establishConnection(namespace: Namespace) {
        
        var nsp: String = ""
        switch namespace {
        case .quiz:
            nsp = "/quiz"
        case .networking:
            nsp = "/networking"
        }
        SocketIOManager.socket = SocketIOManager.manager.socket(forNamespace: nsp)
        SocketIOManager.socket.connect()
    }
    
    
//    func closeConnection() {
//        SocketIOManager.socket.disconnect()
//    }
//
    class func connectSocket(){
        socket.on(clientEvent: .connect) {data, ack in
            print("QUIZ socket connected")
        }
    }
    
    
//    class func getRealtimeData() {
////        socket.on("play", callback: { (data, ack) in
////            print("PLAY: \(data) ")
////        })
//
////        socket.on("realtime", callback: { (data, ack) in
////            let json = JSON(data)
////            timeLeft = json[0]["timeLeft"].intValue
////            numberOfAnswers = json[0]["numberOfAnswers"].intValue
////                            print("REALTIME: \(data)")
////                            print("XX--->>>  \(timeLeft)  ----- \(numberOfAnswers)")
////        })
//    }
    
//    class func login(categories: [Int]) {
//        
//        socket.emit("login", LoginData(deviceID: deviceID, categories: categories)) {
//
//        }
//    }
    
    class func reciveMessage(){

    }
}
