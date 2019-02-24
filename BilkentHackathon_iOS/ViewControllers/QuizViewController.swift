//
//  ViewController.swift
//  BilkentHackathon_iOS
//
//  Created by Mansur Muaz Ekici on 23.02.2019.
//  Copyright © 2019 mmuazekici. All rights reserved.
//

import UIKit
import SwiftyJSON

class QuizViewController: UIViewController {

    @IBOutlet weak var timerLabel: UITextView!
    @IBOutlet weak var questionLabel: UITextView!
    
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var dButton: UIButton!
    
    var timer = Timer()
    var timeLeft:Int? = nil
    var lastTime = 10
    var numberOfAnswers = 0
    var isChecked = false
    var isResults = false
    var trueAnswer: Int? = nil
    var selectedAnswer: Int? = nil
    
    var defaultButtonWidth = Double()
    var defaultButtonHeight = Double()
    
    var name = ""
    var resultsTime = Int()
    
    @IBOutlet weak var readyLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultButtonWidth = Double(aButton.frame.size.width)
        defaultButtonHeight = Double(aButton.frame.size.height)

        self.navigationItem.setHidesBackButton(true, animated:true);

        self.aButton.alpha = 0.2
        self.bButton.alpha = 0.2
        self.cButton.alpha = 0.2
        self.dButton.alpha = 0.2
        
        self.questionLabel.alpha = 1
        
        readyLabel.alpha = 0.7
        
        SocketIOManager.socket.on("general") { (data, ack) in
            let json = JSON(data)
            self.resultsTime = json[0]["stateDurations"]["Result"].intValue
            self.name = json[0]["name"].stringValue
        }
        
        SocketIOManager.socket.on("realtime", callback: { (data, ack) in
            
            let json = JSON(data)
            self.timeLeft = json[0]["timeLeft"].intValue
            self.numberOfAnswers = json[0]["numberOfAnswers"].intValue
            
            self.readyLabel.text = "\(self.numberOfAnswers) cevap verildi."
            
            if let timeLeftInt = self.timeLeft {
                self.timerLabel.text = String(timeLeftInt)
            
                if (timeLeftInt == 20){
                    self.readyLabel.text = "Başla!"
                } else if (timeLeftInt == 0) {
                    self.readyLabel.text = "Bitti!"
                }
            }
                
                
//                if (!self.isChecked) {
//                    self.aButton.alpha = 0.2
//                    self.bButton.alpha = 0.2
//                    self.cButton.alpha = 0.2
//                    self.dButton.alpha = 0.2
//
//                    self.aButton.isEnabled = false
//                    self.bButton.isEnabled = false
//                    self.cButton.isEnabled = false
//                    self.dButton.isEnabled = false
//
//                    self.questionLabel.alpha = 0.2
//
//                    if (self.timeLeft == 20) {
//                        self.isChecked = false
//                        self.isStarted = true
//                        self.readyLabel.text = "Başla!"
//
//                        self.aButton.dropShadow(color: self.aButton.backgroundColor!, opacity: 0, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
//                        self.bButton.dropShadow(color: self.bButton.backgroundColor!, opacity: 0, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
//                        self.cButton.dropShadow(color: self.cButton.backgroundColor!, opacity: 0, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
//                        self.dButton.dropShadow(color: self.dButton.backgroundColor!, opacity: 0, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
//
//                        self.aCheck.alpha = 0
//                        self.bCheck.alpha = 0
//                        self.cCheck.alpha = 0
//                        self.dCheck.alpha = 0
//
//                        self.selectedAnswer = nil
//                    }
//                } else {
//                    if(!self.isChecked) {
//                        self.aButton.alpha = 1
//                        self.bButton.alpha = 1
//                        self.cButton.alpha = 1
//                        self.dButton.alpha = 1
//
//                        self.aButton.isEnabled = true
//                        self.bButton.isEnabled = true
//                        self.cButton.isEnabled = true
//                        self.dButton.isEnabled = true
//                    }
//
//                    self.questionLabel.alpha = 1
//
//                    self.readyLabel.text = "\(self.numberOfAnswers) cevap verildi."
//
//                    if (self.timeLeft == 0) {
//                        self.isStarted = false
//                        self.readyLabel.text = "Süre bitti!"
//                        self.showResults()
//                    }
//                }
//            }
        })
        
        SocketIOManager.socket.on("play", callback: { (data, ack) in
            let json = JSON(data)

            self.questionLabel.text = json[0]["question"]["text"].stringValue
            self.timerLabel.alpha = 1
            
            self.aButton.setTitle(json[0]["question"]["choices"][0].stringValue, for: .normal)
            self.bButton.setTitle(json[0]["question"]["choices"][1].stringValue, for: .normal)
            self.cButton.setTitle(json[0]["question"]["choices"][2].stringValue, for: .normal)
            self.dButton.setTitle(json[0]["question"]["choices"][3].stringValue, for: .normal)

            self.trueAnswer = json[0]["question"]["trueAnswer"].intValue
           
            UIView.animate(withDuration: 0.3) {

                self.enableButtons(button: self.aButton)
                self.enableButtons(button: self.bButton)
                self.enableButtons(button: self.cButton)
                self.enableButtons(button: self.dButton)
            
                self.defaultButtonSize(button: self.aButton)
                self.defaultButtonSize(button: self.bButton)
                self.defaultButtonSize(button: self.cButton)
                self.defaultButtonSize(button: self.dButton)
            }
        })
        
        SocketIOManager.socket.on("results", callback: { (data, ack) in
            let json = JSON(data)
        
            self.readyLabel.text = "Cevap:"
            self.timerLabel.alpha = 0
            
            let aRatio = json[0]["summary"][0].doubleValue
            let bRatio = json[0]["summary"][1].doubleValue
            let cRatio = json[0]["summary"][2].doubleValue
            let dRatio = json[0]["summary"][3].doubleValue

            self.setButtonSize(button: self.aButton, ratio: aRatio)
            self.setButtonSize(button: self.bButton, ratio: bRatio)
            self.setButtonSize(button: self.cButton, ratio: cRatio)
            self.setButtonSize(button: self.dButton, ratio: dRatio)
        
            self.showTrueAnswer()
        })
        
        
//
//        SocketIOManager.socket.on("results", callback: { (data, ack) in
//            let json = JSON(data)
//
//
//
//                self.lastTime = 10
//                self.showResults()
//
//                let aRatio = json[0]["summary"][0].intValue
//                let bRatio = json[0]["summary"][1].intValue
//                let cRatio = json[0]["summary"][2].intValue
//                let dRatio = json[0]["summary"][3].intValue
//
//                self.setButtonSize(button: self.aButton, ratio: Double(aRatio))
//                self.setButtonSize(button: self.bButton, ratio: Double(bRatio))
//                self.setButtonSize(button: self.cButton, ratio: Double(cRatio))
//                self.setButtonSize(button: self.dButton, ratio: Double(dRatio))
//
//
//        })
    }

    @IBAction func aSelected(_ sender: Any) {
        isChecked = true
        self.selectedAnswer = 0
        
        self.aButton.dropShadow(color: darkerColorForColor(color: aButton.backgroundColor!), opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
        
        SocketIOManager.socket.emit("move", ChoiceData(choice: 0))
        
        self.aButton.alpha = 1
        self.bButton.alpha = 0.2
        self.cButton.alpha = 0.2
        self.dButton.alpha = 0.2
        
        self.aButton.isEnabled = false
        self.bButton.isEnabled = false
        self.cButton.isEnabled = false
        self.dButton.isEnabled = false
    }
    @IBAction func bSelected(_ sender: Any) {
        isChecked = true
        self.selectedAnswer = 1

        self.bButton.dropShadow(color: darkerColorForColor(color: bButton.backgroundColor!), opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
        
        SocketIOManager.socket.emit("move", ChoiceData(choice: 1))
        
        self.aButton.alpha = 0.2
        self.bButton.alpha = 1
        self.cButton.alpha = 0.2
        self.dButton.alpha = 0.2
        
        self.aButton.isEnabled = false
        self.bButton.isEnabled = false
        self.cButton.isEnabled = false
        self.dButton.isEnabled = false
    }
    @IBAction func cSelected(_ sender: Any) {
        isChecked = true
        self.selectedAnswer = 2

        self.cButton.dropShadow(color: darkerColorForColor(color: cButton.backgroundColor!), opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
        
        SocketIOManager.socket.emit("move", ChoiceData(choice: 2))
        
        self.aButton.alpha = 0.2
        self.bButton.alpha = 0.2
        self.cButton.alpha = 1
        self.dButton.alpha = 0.2
        
        self.aButton.isEnabled = false
        self.bButton.isEnabled = false
        self.cButton.isEnabled = false
        self.dButton.isEnabled = false
    }
    @IBAction func dSelected(_ sender: Any) {
        isChecked = true
        self.selectedAnswer = 3
        
        self.dButton.dropShadow(color: darkerColorForColor(color: dButton.backgroundColor!), opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
        
        SocketIOManager.socket.emit("move", ChoiceData(choice: 3))
        
        self.aButton.alpha = 0.2
        self.bButton.alpha = 0.2
        self.cButton.alpha = 0.2
        self.dButton.alpha = 1
        
        self.aButton.isEnabled = false
        self.bButton.isEnabled = false
        self.cButton.isEnabled = false
        self.dButton.isEnabled = false
    }
    
    func darkerColorForColor(color: UIColor) -> UIColor {
        
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
        }
        
        return UIColor()
    }
    
    func showTrueAnswer() {
        
        if let trueAnswerInt = trueAnswer {

            if (selectedAnswer != trueAnswerInt) {
                switch selectedAnswer {
                case 0:
                    self.aButton.dropShadow(color: .red, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
                case 1:
                    self.bButton.dropShadow(color: .red, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
                case 2:
                    self.cButton.dropShadow(color: .red, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
                case 3:
                    self.dButton.dropShadow(color: .red, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
                default:
                    break
                }
                
                switch trueAnswerInt {
                case 0:
                    self.aButton.alpha = 0.9
                    self.aButton.dropShadow(color: .blue, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
                case 1:
                    self.bButton.alpha = 0.9
                    self.bButton.dropShadow(color: .blue, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
                case 2:
                    self.cButton.alpha = 0.9
                    self.cButton.dropShadow(color: .blue, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
                case 3:
                    self.dButton.alpha = 0.9
                    self.dButton.dropShadow(color: .blue, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
                default:
                    break
                }
            } else {
                switch selectedAnswer {
                case 0:
                    self.aButton.dropShadow(color: .green, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
                case 1:
                    self.bButton.dropShadow(color: .green, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
                case 2:
                    self.cButton.dropShadow(color: .green, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
                case 3:
                    self.dButton.dropShadow(color: .green, opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
                default:
                    break
                }
            }
        }
    }
    
    func setButtonSize(button: UIButton, ratio: Double) {
        
        var tempRatio = ratio
        
        if tempRatio == 0 {
            tempRatio = 0.1
        }
        
        button.dropShadow(color: .red, opacity: 0, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
        
        let buttonWidth = Double(button.frame.size.width) * tempRatio
        let buttonHeight = Double(button.frame.size.height)
        
        UIView.animate(withDuration: 0.3) {
            button.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
            button.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func defaultButtonSize(button: UIButton) {
        
        button.dropShadow(color: .red, opacity: 0, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
        
        button.frame.size = CGSize(width: self.defaultButtonWidth, height: self.defaultButtonHeight)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func enableButtons(button: UIButton) {
        button.alpha = 1
        button.isEnabled = true
    }
}

