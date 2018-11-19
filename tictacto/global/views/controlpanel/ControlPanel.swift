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
    override func reset()
    {
        guard
            self.restartBtn.title(for: .normal)?.range(of: "CLEAR") == nil
        else
        {
            return
        }
        
        self.restartBtn.setTitle("CLEAR SCORES", for: .normal)
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
        // Game is in progress, make sure restart btn says round
        guard
            self.restartBtn.title(for: .normal)?.range(of: "ROUND") == nil
        else
        {
            return
        }
        
        self.restartBtn.setTitle("RESTART ROUND", for: .normal)
    }
    
    func pause()
    {
        self.shouldRespond = false
    }
    
    func unPause()
    {
        guard
            !self.shouldRespond
        else
        {
            return
        }
        
        self.shouldRespond = true
        self.restartBtn.setTitle("START NEW ROUND", for: .normal)
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
