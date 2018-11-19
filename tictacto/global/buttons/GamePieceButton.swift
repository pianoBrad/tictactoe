//
//  GamePieceButton.swift
//  tictacto
//
//  Created by Keithon Stribling on 10/19/18.
//  Copyright © 2018 megaBreezy. All rights reserved.
//

import UIKit

protocol GamePieceButtonDelegate: class
{
	func gamePieceTapped(_ sender : GamePieceButton)
    func gamePieceTitleUpdated(_ sender : GamePieceButton)
}

@IBDesignable
class GamePieceButton: UIButton
{

	/** Properties **/
	weak var btnDelegate : GamePieceButtonDelegate?
    @IBInspectable var column : Int = 0
    @IBInspectable var row : Int = 0
    var owner : Player?
    
	/** Overrides **/
	override init(frame: CGRect)
	{
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		commonInit()
	}
	
	/** Custom Methods **/
	func commonInit()
	{
        self.titleLabel?.font = UIFont.systemFont(ofSize: 60, weight: .black)
        self.setTitleColor(UIColor(hexFromString: "#333333"), for: .normal)
        self.setTitle("", for: .normal)
        
        self.enable()
    }
    
    public func mark(forPlayer: Player)
    {
        self.owner = forPlayer
        self.setTitleColor(forPlayer.color, for: .normal)
        self.draw(symbol: forPlayer.symbol)
    }
    
    private func draw(symbol: String)
    {
        self.setTitle(symbol, for: .normal)
        // Adding a delay b/c of the animation in setTitle
        DispatchQueue.main.asyncAfter(
            deadline: .now() + .milliseconds(300),
            execute:
            {
                self.btnDelegate?.gamePieceTitleUpdated(self)
            }
        )
    }
    
    public func enable()
    {
        self.addTarget(
            self, action: #selector(handleBtnPress), for: .touchUpInside
        )
    }
    
    public func disable()
    {
        self.removeTarget(nil, action: nil, for: .allEvents)
    }
    
    public func reset()
    {
        self.owner = nil
        self.setTitle("", for: .normal)
        self.enable()
    }
    
    public func hasBeenPlayed() -> Bool
    {
        return self.owner != nil ? true : false
    }
	
    /** Actions **/
	@objc func handleBtnPress(_ sender : GamePieceButton)
	{
		btnDelegate?.gamePieceTapped(self)
	}
}
