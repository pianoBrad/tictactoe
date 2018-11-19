//
//  TicTacToeVC.swift
//  tictacto
//
//  Created by Brad Phillips on 10/12/18.
//  Copyright © 2018 megaBreezy. All rights reserved.
//

import UIKit

class TicTacToeVC: UIViewController
{
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var gameBoard: GameBoard!
    @IBOutlet weak var controlPanel: ControlPanel!
	
	override func viewDidLoad()
	{
        playerView.playersDelegate = self
        gameBoard.boardDelegate = self
        controlPanel.panelDelegate = self
    }
    
    /** Custom methods **/
    func startGame()
    {
        currentGame.reset()
        playerView.reset()
        gameBoard.reset()
        controlPanel.reset()
    }
    
    func endGame()
    {
        playerView.end()
        gameBoard.end()
    }
}

extension TicTacToeVC : PlayerViewDelegate
{
    func nextPlayerShouldTakeTurn()
    {
        gameBoard.beginTurn()
    }
}

extension TicTacToeVC : ControlPanelDelegate
{
    func restartBtnWasPress(_ sender: ControlPanelBtn)
    {
        self.startGame()
    }
}

extension TicTacToeVC : GameBoardDelegate
{
    func foundThreeInARow(forPlayer: Player)
    {
        currentGame.declareWinner(player: forPlayer)
        endGame()
    }
    
    func filledWithoutThreeInARow()
    {
        currentGame.declareDraw()
        endGame()
    }
    
    func readyForNextTurn()
    {
        currentGame.markShouldNotRestart()
        playerView.changeActivePlayer()
        self.controlPanel.checkShouldMarkGameInProgress()
    }
    
    func matchingAnimationBegan()
    {
        self.controlPanel.pause()
    }
    
    func matchingAnimationComplete()
    {
        self.controlPanel.unPause()
    }
}
