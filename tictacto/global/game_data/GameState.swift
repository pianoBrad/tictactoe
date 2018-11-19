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
    var players : [Player] = []
    var playerColors : [UIColor] = [
        UIColor(hexFromString: "#545454"),
        UIColor(hexFromString: "#F2EBD4")
    ]
    var curPlayer : Player?
    var winner : Player?
    var shouldRestart : Bool = false
    
    /** Custom methods **/
    public func add(player : Player)
    {
        self.players.append(player)
        
        guard
            let firstColor = playerColors.first,
            let lastColor = playerColors.last
        else
        {
            return
        }
        
        switch (players.count % 2)
        {
        case 0:
            player.color = lastColor
        default:
            player.color = firstColor
        }
    }
    
    public func getCurrentPlayer() -> Player?
    {
        for player in self.players
        {
            if let btn = player.btn, btn.isActive
            {
                self.curPlayer = player
                return curPlayer
            }
        }
        
        self.curPlayer = nil
        return nil
    }
    
    public func getScore() -> [Int]
    {
        var score : [Int] = []
        for player in players
        {
            score.append(player.score)
        }
        
        return score
    }
    
    public func reset()
    {
        if self.checkShouldRestart()
        {
            for player in self.players
            {
                player.resetScore()
            }
        }
        else
        {
            self.shouldRestart = true
        }
        
        self.winner = nil
        self.resetPlayerTurns()
    }
    
    public func declareWinner(player: Player)
    {
        self.shouldRestart = false
        self.winner = player
        player.updateScore()
    }
    
    public func declareDraw()
    {
        self.shouldRestart = false
        self.winner = nil
    }
    
    public func markShouldNotRestart()
    {
        self.shouldRestart = false
    }
    
    private func resetPlayerTurns()
    {
        for player in players
        {
            player.btn?.changeButtonState(setActive: false)
        }
        if let firstPlayer = players.first
        {
            firstPlayer.btn?.changeButtonState(setActive: true)
        }
    }
    
    private func checkShouldRestart() -> Bool
    {
        if (self.winner == nil && self.curPlayer == nil)
            || self.shouldRestart
        {
            return true
        }
        
        return false
    }
}

let currentGame = GameState()
