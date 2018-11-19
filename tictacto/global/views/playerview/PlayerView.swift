//
//  PlayerView.swift
//  tictacto
//
//  Created by Brad Phillips on 10/12/18.
//  Copyright © 2018 megaBreezy. All rights reserved.
//

import UIKit

protocol PlayerViewDelegate : class
{
    func nextPlayerShouldTakeTurn()
}

@IBDesignable
class PlayerView: GameSectionView
{
	/** Properties **/
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var playerXBtn: PlayerButton!
    @IBOutlet weak var playerOBtn: PlayerButton!
    @IBOutlet weak var gameStatusLabel: GameStatusLabel!
    
    weak var playersDelegate : PlayerViewDelegate?
    var playerBtns : [PlayerButton] = []
    
	/** Overrides **/
    
    /** Custom Methods **/
    override func commonInit()
    {
        super.commonInit()
        let bundle = Bundle(for: PlayerView.self)
        bundle.loadNibNamed(
            String(describing: PlayerView.self), owner: self, options: nil)
        
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        playerBtns = [playerXBtn, playerOBtn]
        
        for btn in playerBtns
        {
            btn.buttonDelegate = self
            let player = Player(withButton: btn)
            currentGame.add(player: player)
        }
    }
    
    override func reset()
    {
        super.reset()
        gameStatusLabel.reset()
    }
    
    override func end()
    {
        super.end()
        
        if let winner = currentGame.winner
        {
            gameStatusLabel.text = "Player \(winner.symbol) wins!"
            return
        }
        
        gameStatusLabel.text = "Draw!"
    }
    
    /** Custom methods **/
    func changeActivePlayer()
    {
        playerXBtn.changeButtonState()
        playerOBtn.changeButtonState()
        
        updateCurPlayerStatus()
        playersDelegate?.nextPlayerShouldTakeTurn()
    }
    
    func updateCurPlayerStatus()
    {
        if let curPlayer = currentGame.getCurrentPlayer()
        {
            gameStatusLabel.text = "Player \(curPlayer.symbol) Turn"
        }
        else
        {
            gameStatusLabel.text = "No players available"
        }
    }
}

extension PlayerView: PlayerButtonDelegate
{
    func buttonTapped(_ sender: PlayerButton) {}
}
