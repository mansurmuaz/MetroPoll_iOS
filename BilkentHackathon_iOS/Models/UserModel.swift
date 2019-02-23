//
//  UserModel.swift
//  BilkentHackathon_iOS
//
//  Created by Mansur Muaz Ekici on 23.02.2019.
//  Copyright © 2019 mmuazekici. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserModel {
    
    var deviceID: String
    
    
    required init(json: JSON) {
        self.deviceID = (UIDevice.current.identifierForVendor?.uuidString)!

    }
}
