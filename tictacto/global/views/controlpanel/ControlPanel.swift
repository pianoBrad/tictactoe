//
//  ControlPanel.swift
//  tictacto
//
//  Created by Brad Phillips on 10/12/18.
//  Copyright © 2018 megaBreezy. All rights reserved.
//

import UIKit

protocol ControlPanelDelegate : class
{
    func restartBtnWasPress(_ sender : ControlPanelBtn);
}

@IBDesignable
class ControlPanel: GameSectionView
{
    /** Properties **/
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var restartBtn: ControlPanelBtn!
    
    var shouldRespond : Bool = true
    var availableHeight : CGFloat = 0
    weak var panelDelegate : ControlPanelDelegate?

    /** Overrides **/
    override func end()
    {
        self.checkRestartBtnTitleShouldChange()
    }
    
    override func reset()
    {
        self.checkRestartBtnTitleShouldChange()
    }
    
    /** Custom Method **/
    override func commonInit()
    {
        self.backgroundColor = UIColor(hexFromString: "#F8F8F8")
        self.availableHeight = self.frame.height
        
        let bundle = Bundle(for: ControlPanel.self)
        bundle.loadNibNamed(
            String(describing: ControlPanel.self), owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    
        restartBtn.btnDelegate = self
    }
    
    func checkShouldMarkGameInProgress()
    {
        // Game is in progress, make sure restart btn says round, not game
        guard
            self.restartBtn.title(for: .normal)?.range(of: "ROUND") == nil
        else
        {
            return
        }
        
        self.checkRestartBtnTitleShouldChange()
    }
    
    func checkRestartBtnTitleShouldChange()
    {
        let curBtnTitle = self.restartBtn.title(for: .normal)
        let gameScope = curBtnTitle?.range(of: "ROUND") != nil ? "GAME" : "ROUND"
        let scoresAboveZero = currentGame.getScore().filter {$0 > 0}
        
        guard
            "RESTART \(gameScope)" != self.restartBtn.title(for: .normal)
        else
        {
            return
        }
                
        if scoresAboveZero.isEmpty { return }
        else if currentGame.winner == nil
        {
            self.restartBtn.setTitle("RESTART \(gameScope)", for: .normal)
        }
        else
        {
            self.restartBtn.setTitle("START NEW ROUND", for: .normal)
        }
    }
    
    func pause()
    {
        self.shouldRespond = false
    }
    
    func unPause()
    {
        self.shouldRespond = true
    }
}

extension ControlPanel : ControlPanelBtnDelegate
{
    func controlBtnPressed(_ sender: ControlPanelBtn)
    {
        guard
            shouldRespond
        else
        {
            return
        }
        
        switch sender
        {
        case restartBtn:
            panelDelegate?.restartBtnWasPress(sender)
            break
        default:
            break
        }
    }
}
