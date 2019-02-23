//
//  GameStateModel.swift
//  BilkentHackathon_iOS
//
//  Created by Mansur Muaz Ekici on 23.02.2019.
//  Copyright © 2019 mmuazekici. All rights reserved.
//

import Foundation
import SwiftyJSON

enum GameState {
    case Play
    case Ads
    case Result
}


class GameStateModel {
    
    var gameState: GameState
    
    
    required init(json: JSON) {
       self.gameState = GameState.Play
    }
}
