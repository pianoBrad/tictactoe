//
//  GameState.swift
//  tictacto
//
//  Created by Brad Phillips on 11/1/18.
//  Copyright © 2018 megaBreezy. All rights reserved.
//

import UIKit

class GameState: NSObject
{
    /** Properties **/
    let players : [Player] = [
        Player(withSymbol: "X"), Player(withSymbol: "O")
    ]
}

let currentGame = GameState()
