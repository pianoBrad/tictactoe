//
//  GameStatusLabel.swift
//  tictacto
//
//  Created by Brad Phillips on 10/28/18.
//  Copyright © 2018 megaBreezy. All rights reserved.
//

import UIKit

class GameStatusLabel: UILabel
{
    /** Properties **/
    let resetText = "Start game or select player"
    
    /** Custom methods **/
    func reset()
    {
        self.text = resetText
    }
}
