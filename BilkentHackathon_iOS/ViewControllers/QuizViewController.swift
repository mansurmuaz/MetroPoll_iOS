//
//  ViewController.swift
//  BilkentHackathon_iOS
//
//  Created by Mansur Muaz Ekici on 23.02.2019.
//  Copyright © 2019 mmuazekici. All rights reserved.
//

import UIKit
import SocketIO

class QuizViewController: UIViewController {

    @IBOutlet weak var timerLabel: UITextView!
    @IBOutlet weak var questionLabel: UITextView!
    
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var dButton: UIButton!
   
    @IBOutlet weak var aCheck: UIImageView!
    @IBOutlet weak var bCheck: UIImageView!
    @IBOutlet weak var cCheck: UIImageView!
    @IBOutlet weak var dCheck: UIImageView!
    

    let manager = SocketManager(socketURL: URL(string: "http://104.248.131.83:8080")!, config: [.log(true), .compress])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aCheck.alpha = 0
        bCheck.alpha = 0
        cCheck.alpha = 0
        dCheck.alpha = 0
       
        let socket = manager.defaultSocket

        socket.on(clientEvent: .connect) {data, ack in
            print("XXX socket connected")
        }
        
        
    }

    @IBAction func aSelected(_ sender: Any) {   
    }
    
    @IBAction func bSelected(_ sender: Any) {
    }
    
    @IBAction func cSelected(_ sender: Any) {
    }
    
    @IBAction func dSelected(_ sender: Any) {
    }
    
   
}

