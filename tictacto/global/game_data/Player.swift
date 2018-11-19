//
//  Player.swift
//  tictacto
//
//  Created by Brad Phillips on 11/1/18.
//  Copyright © 2018 megaBreezy. All rights reserved.
//

import UIKit

protocol PlayerDelegate : class
{
    func scoreWasUpdated(_ sender : Player)
}

class Player: NSObject
{
    /** Properties **/
    public var btn : PlayerButton?
    public var symbol : String = "X"
    public var color : UIColor = .black
    public var score : Int = 0
    weak var delegate : PlayerDelegate?
    
    /** Overrides **/
    convenience init(withButton: PlayerButton)
    {
        self.init()
        self.btn = withButton
        self.delegate = withButton
        if let btnSymbol = withButton.playerNameLabel.text
        {
            self.symbol = btnSymbol
        }
    }
    
    /** Custom methods **/
    public func resetScore()
    {
        self.score = 0
        self.delegate?.scoreWasUpdated(self)
    }
    public func updateScore(winner: Bool? = true)
    {
        guard
            let wasVictorious = winner,
            wasVictorious
        else {
            self.score -= 1
            return
        }
        
        self.score += 1
        self.delegate?.scoreWasUpdated(self)
    }
}
