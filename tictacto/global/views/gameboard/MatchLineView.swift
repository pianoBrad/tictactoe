//
//  MatchLineView.swift
//  tictacto
//
//  Created by Brad Phillips on 11/13/18.
//  Copyright © 2018 megaBreezy. All rights reserved.
//

import UIKit

protocol MatchLineViewDelegate : class
{
    func lineAddedToSuperView(_ sender : MatchLineView)
    func lineDrawComplete(_ sender : MatchLineView)
}

class MatchLineView: UIView
{
    /** Properties **/
    var matchType : String = "horizontal"
    var firstMatchingBtn : GamePieceButton?
    var middleMatchingBtn : GamePieceButton?
    var frameCenterPoint : CGPoint = CGPoint(x: 0, y: 0)
    var widthConst : NSLayoutConstraint?
    var heightConst : NSLayoutConstraint?
    let lineAnimator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut)
    
    weak var lineDelegate : MatchLineViewDelegate?
    
    /** Overrides **/
    override func draw(_ rect: CGRect)
    {
        drawLine()
    }
    
    convenience init(with matchType: String, for row: [GamePieceButton])
    {
        self.init(frame: .zero)
        //self.backgroundColor = .blue
        self.backgroundColor = .clear
        //self.alpha = 0.5
        self.firstMatchingBtn = row.first
        self.middleMatchingBtn = row.middle
        self.matchType = matchType        
    }
    
    override func didMoveToSuperview()
    {
        self.setupStartingConstraints()
    }
    
    /** Custom methods **/
    func getLineFrameForWin() -> CGRect?
    {
        var newRect = CGRect(
            x: 0,
            y: 0,
            width: self.matchType == "horizontal" ? 0 : self.frame.width,
            height: self.matchType == "vertical" ? 0 : self.frame.height
        )
        
        if self.matchType == "diagonal"
        {
            newRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        
        return newRect
    }
    
    func drawLine()
    {
        guard
            let winner = currentGame.winner,
            let firstBtn = self.firstMatchingBtn,
            let middleBtn = self.middleMatchingBtn,
            self.frame.width > 0,
            self.frame.height > 0
        else
        {
            return
        }
        
        var lineStartPoint = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        var lineEndPoint = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        
        switch self.matchType
        {
        case "vertical":
            self.frameCenterPoint = CGPoint(
                x: middleBtn.frame.origin.x + (middleBtn.frame.width/2),
                y: self.center.y
            )
            lineStartPoint.y = 0
            lineEndPoint.y = self.frame.height
            break
        case "horizontal":
            self.frameCenterPoint = CGPoint(
                x: self.center.x,
                y: middleBtn.frame.origin.y + (middleBtn.frame.height/2)
            )
            lineStartPoint.x = 0
            lineEndPoint.x = self.frame.width
            break
        default: //diagonal
            self.frameCenterPoint = middleBtn.center
            lineStartPoint.x = 0
            lineStartPoint.y = firstBtn.center.x < middleBtn.center.x
                ? 0
                : self.frame.height
            lineEndPoint.x = self.frame.width
            lineEndPoint.y = firstBtn.center.x > middleBtn.center.x
                ? 0
                : self.frame.height
            break
        }
        
        self.center = self.frameCenterPoint
        
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint( x: lineStartPoint.x, y: lineStartPoint.y ) )
        aPath.addLine( to: CGPoint( x: lineEndPoint.x, y: lineEndPoint.y ) )
        
        aPath.close()
        
        winner.color.setStroke()
        aPath.lineWidth = 5.0
        aPath.stroke()
    }
    
    func setupStartingConstraints()
    {
        guard
            let parent = self.superview
        else
        {
            return
        }
        
        var widthConstant : CGFloat = 0
        var heightConstant : CGFloat = 0
        
        switch self.matchType
        {
        case "vertical":
            widthConstant = parent.frame.height
            break
        case "horizontal" :
            heightConstant = parent.frame.width
            break
        default: // diagonal
            break
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let topConst = NSLayoutConstraint(
            item: self, attribute: .top,
            relatedBy: .equal, toItem: parent, attribute: .top,
            multiplier: 1, constant: 0
        )
        let leadingConst = NSLayoutConstraint(
            item: self, attribute: .leading,
            relatedBy: .equal, toItem: parent, attribute: .leading,
            multiplier: 1, constant: 0
        )
        let wConst = NSLayoutConstraint(
            item: self, attribute: .width,
            relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
            multiplier: 1, constant: widthConstant
        )
        let hConst = NSLayoutConstraint(
            item: self, attribute: .height,
            relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
            multiplier: 1, constant: heightConstant
        )
        
        self.widthConst = wConst
        self.heightConst = hConst
        parent.addConstraints([
            topConst, leadingConst, wConst, hConst
        ])
        parent.layoutIfNeeded()
        
        lineDelegate?.lineAddedToSuperView(self)
    }
    
    func animateLine()
    {
        guard
            let parent = self.superview,
            let wConst = self.widthConst,
            let hConst = self.heightConst
        else
        {
            return
        }
        
        self.lineAnimator.addAnimations
        {
            switch self.matchType
            {
            case "vertical":
                hConst.constant = parent.frame.height
                break
            case "horizontal":
                wConst.constant = parent.frame.width
                break
            default: // diagonal
                hConst.constant = parent.frame.height
                wConst.constant = parent.frame.width
            }
            
            parent.layoutIfNeeded()
        }
        
        self.lineAnimator.addCompletion
        {
            _ in
            
            self.lineDelegate?.lineDrawComplete(self)
        }
        
        self.lineAnimator.startAnimation()
    }
}
