//
//  CategoriesViewController.swift
//  BilkentHackathon_iOS
//
//  Created by Mansur Muaz Ekici on 23.02.2019.
//  Copyright © 2019 mmuazekici. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    var categories: [Int] = []
    
    @IBOutlet weak var cultureButton: UIView!
    @IBOutlet weak var historyButton: UIView!
    @IBOutlet weak var geographyButton: UIView!
    @IBOutlet weak var artButton: UIView!
    @IBOutlet weak var sportButton: UIView!
    @IBOutlet weak var literatureButton: UIView!
    @IBOutlet weak var musicButton: UIView!
    @IBOutlet weak var movieButton: UIView!
    
    let deviceID = (UIDevice.current.identifierForVendor?.uuidString)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Başla", style: .done, target: self, action: #selector(startButtonTapped))

        SocketIOManager.sharedInstance.establishConnection(namespace: .quiz)

        SocketIOManager.connectSocket()
        
        cultureButton.alpha = 0.7
        historyButton.alpha = 0.7
        geographyButton.alpha = 0.7
        artButton.alpha = 0.7
        sportButton.alpha = 0.7
        literatureButton.alpha = 0.7
        musicButton.alpha = 0.7
        movieButton.alpha = 0.7
        
        var gesture = UITapGestureRecognizer(target: self, action: #selector(CultureTapped))
        cultureButton.addGestureRecognizer(gesture)
        gesture = UITapGestureRecognizer(target: self, action: #selector(HistoryTapped))
        historyButton.addGestureRecognizer(gesture)
        gesture = UITapGestureRecognizer(target: self, action: #selector(GeographyTapped))
        geographyButton.addGestureRecognizer(gesture)
        gesture = UITapGestureRecognizer(target: self, action: #selector(ArtTapped))
        artButton.addGestureRecognizer(gesture)
        gesture = UITapGestureRecognizer(target: self, action: #selector(SportTapped))
        sportButton.addGestureRecognizer(gesture)
        gesture = UITapGestureRecognizer(target: self, action: #selector(LiteratureTapped))
        literatureButton.addGestureRecognizer(gesture)
        gesture = UITapGestureRecognizer(target: self, action: #selector(MusicTapped))
        musicButton.addGestureRecognizer(gesture)
        gesture = UITapGestureRecognizer(target: self, action: #selector(MovieTapped))
        movieButton.addGestureRecognizer(gesture)

    }
    
    
    @objc func CultureTapped() {
        handleTap(index: 0, buttonView: cultureButton)
    }
    @objc func HistoryTapped() {
        handleTap(index: 1, buttonView: historyButton)
    }
    @objc func GeographyTapped() {
        handleTap(index: 2, buttonView: geographyButton)
    }
    @objc func ArtTapped() {
        handleTap(index: 3, buttonView: artButton)
    }
    @objc func SportTapped() {
        handleTap(index: 4, buttonView: sportButton)
    }
    @objc func LiteratureTapped() {
        handleTap(index: 5, buttonView: literatureButton)
    }
    @objc func MusicTapped() {
        handleTap(index: 6, buttonView: musicButton)
    }
    @objc func MovieTapped() {
        handleTap(index: 7, buttonView: movieButton)
    }
    
    func handleTap(index: Int, buttonView: UIView) {
        if !categories.contains(index) {
            categories.append(index)
            
           buttonView.alpha = 1
            
            buttonView.dropShadow(color: darkerColorForColor(color: buttonView.backgroundColor!), opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
        } else {
            
            buttonView.alpha = 0.7
            categories = categories.filter {$0 != index}
            buttonView.dropShadow(color: buttonView.backgroundColor!, opacity: 0, offSet: CGSize(width: 0, height: 0), radius: 0, scale: true)
        }
        print(categories.description)
    }
 
    func darkerColorForColor(color: UIColor) -> UIColor {
        
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
        }
        
        return UIColor()
    }
    
    @objc func startButtonTapped() {
    
        // Send categories to server
        SocketIOManager.socket.emit("login", LoginData(deviceID: deviceID, categories: categories))
        print("XXX Logged in!")
        self.performSegue(withIdentifier: "startQuiz", sender: self)
    }
}

extension UIView {
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
