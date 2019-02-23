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
        handleTap(index: 0, view: cultureButton)
    }
    @objc func HistoryTapped() {
        handleTap(index: 1, view: historyButton)
    }
    @objc func GeographyTapped() {
        handleTap(index: 2, view: geographyButton)
    }
    @objc func ArtTapped() {
        handleTap(index: 3, view: artButton)
    }
    @objc func SportTapped() {
        handleTap(index: 4, view: sportButton)
    }
    @objc func LiteratureTapped() {
        handleTap(index: 5, view: literatureButton)
    }
    @objc func MusicTapped() {
        handleTap(index: 6, view: musicButton)
    }
    @objc func MovieTapped() {
        handleTap(index: 7, view: movieButton)
    }
    
    func handleTap(index: Int, view: UIView) {
        if !categories.contains(index) {
            categories.append(index)
            
            
            view.dropShadow(color: darkerColorForColor(color: view.backgroundColor!), opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 6, scale: true)
        } else {
            categories = categories.filter {$0 != index}
            view.dropShadow(color: view.backgroundColor!, opacity: 0, offSet: CGSize(width: 0, height: 0), radius: 0, scale: true)
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
        SocketIOManager.socket.emit("login", LoginData(deviceID: deviceID, categories: categories)) {
            print("XXXX ccc done")
            self.performSegue(withIdentifier: "startQuiz", sender: self)
        }
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
