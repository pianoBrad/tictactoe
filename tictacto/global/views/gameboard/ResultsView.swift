//
//  ResultsView.swift
//  tictacto
//
//  Created by Brad Phillips on 11/17/18.
//  Copyright © 2018 megaBreezy. All rights reserved.
//

import UIKit

@IBDesignable
class ResultsView: UIView
{
    /** Properties **/
    @IBOutlet var contentView: UIView!
    @IBOutlet var playerLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    
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
    
    func commonInit()
    {
        self.isUserInteractionEnabled = false
        self.backgroundColor = .clear
        let bundle = Bundle(for: ResultsView.self)
        bundle.loadNibNamed(
            String(describing: ResultsView.self), owner: self, options: nil
        )
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupFontAttributes(for: playerLabel)
        self.textLabel.textColor = UIColor(hexFromString: "#545454")
    }
    
    /** Custom methods **/
    func setupFontAttributes(for label: UILabel)
    {
        label.font = UIFont.systemFont(ofSize: 1000, weight: .bold)
        label.minimumScaleFactor = 0.1   //or whatever suits your need
        label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byClipping
        label.numberOfLines = 0
        
        textLabel.font = UIFont.systemFont(ofSize: 50, weight: .bold)
    }
    
    func updateMessage()
    {
        if let winner = currentGame.winner
        {
            self.playerLabel.textColor = winner.color
            self.playerLabel.text = winner.symbol
            self.textLabel.text = "WINNER!"
        }
        else
        {
            self.playerLabel.textColor = UIColor(hexFromString: "#545454")
            self.playerLabel.text = "XO"
            self.textLabel.text = "DRAW!"
        }
    }
    
    func setPosition(hidden: Bool)
    {
        switch hidden
        {
        case true:
            self.alpha = 0
            self.contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.contentView.center.y = self.center.y + 50
            break
        default:
            self.alpha = 1
            self.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.contentView.center.y = self.center.y - 50
        }
    }
}
