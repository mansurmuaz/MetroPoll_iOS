//
//  QuestionModel.swift
//  BilkentHackathon_iOS
//
//  Created by Mansur Muaz Ekici on 23.02.2019.
//  Copyright © 2019 mmuazekici. All rights reserved.
//

import Foundation
import SwiftyJSON

class QuestionModel {
    
    var text: String!
    var choices: [String]!
    var trueAnswer: Int!
    
    required init(json: JSON) {
        
        self.text = json["text"].stringValue
        self.choices = json.arrayValue.map({$0["choices"].stringValue})
        self.trueAnswer = json["trueAnswer"].intValue
    }
}
