//
//  PlayerButton.swift
//  tictacto
//
//  Created by Keithon Stribling on 10/23/18.
//  Copyright © 2018 megaBreezy. All rights reserved.
//

import UIKit

protocol PlayerButtonDelegate : class
{
	func buttonTapped(_ sender: PlayerButton)
}

@IBDesignable
class PlayerButton: UIView
{

	/** Properties **/
	@IBOutlet var contentView: UIView!
	@IBOutlet weak var playerTurnIndicator: UIView!
	@IBOutlet weak var playerNameLabel: UILabel!
	@IBOutlet weak var playerScoreLabel: UILabel!
	
	weak var buttonDelegate: PlayerButtonDelegate?
	
	@IBInspectable var isActive: Bool = false
	{
		didSet
		{
			changeButtonState(setActive: isActive, shouldUpdateSelf: nil)
		}
	}
	
	@IBInspectable var playerLabel: String = ""
	{
		didSet
		{
			playerNameLabel.text = playerLabel
		}
	}
	
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
	private func commonInit()
	{
		let bundle = Bundle(for: PlayerButton.self)
		bundle.loadNibNamed(String(describing: PlayerButton.self), owner: self, options: nil)
		
		self.addSubview(contentView)
		contentView.frame = self.bounds
		contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.25
        self.clipsToBounds = false
        setShadowDepth()
        
		let gesture = UITapGestureRecognizer(target: self, action: #selector(checkTap))
		self.addGestureRecognizer(gesture)
	}
	
	public func changeButtonState(
        setActive: Bool? = nil, shouldUpdateSelf : Bool? = true)
	{
        if (shouldUpdateSelf != nil)
        {
            self.isActive = setActive != nil
                ? setActive!
                : !self.isActive
        }

        let activeState = setActive != nil
            ? setActive
            : self.isActive
        
        // Update button to reflect new state
		switch activeState
		{
		case true:
			self.playerTurnIndicator.backgroundColor = UIColor.init(
                hexFromString: "#26BCAC"
            )
			break
		default:
			self.playerTurnIndicator.backgroundColor = .clear
			break
		}
        
        setShadowDepth()
	}
    
    private func setShadowDepth()
    {
        switch self.isActive
        {
        case true:
            contentView.layer.shadowOffset = CGSize(width: 0, height: 3)
            contentView.layer.shadowRadius = 2
            break
        default:
            contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
            contentView.layer.shadowRadius = 1
            break
        }
    }
    
    /** Actions **/
	@objc func checkTap(_ sender: UITapGestureRecognizer)
	{
		buttonDelegate?.buttonTapped(self)
	}
}

extension PlayerButton : PlayerDelegate
{
    func scoreWasUpdated(_ sender: Player)
    {
        guard
            sender.score > 0
        else
        {
            self.playerScoreLabel.text = "-"
            return
        }
        self.playerScoreLabel.text = String(sender.score)
    }
}
