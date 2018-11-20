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
        self.backgroundColor = .clear
        self.firstMatchingBtn = row.first
        self.middleMatchingBtn = row.middle
        self.matchType = matchType        
    }
    
    override func didMoveToSuperview()
    {
        if let startFrame = getFrame(for: matchType, isFinalPosition: false)
        {
            self.frame = startFrame
            lineDelegate?.lineAddedToSuperView(self)
        }
    }
    
    /** Custom methods **/
    public func getLineFrameForWin() -> CGRect?
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
    
    func animateLine()
    {
        guard
            let endFrame = getFrame(for: self.matchType, isFinalPosition: true)
        else
        {
            return
        }
        
        self.lineAnimator.addAnimations
        {
            self.frame = endFrame
        }
        
        self.lineAnimator.addCompletion
        {
            _ in
            
            self.lineDelegate?.lineDrawComplete(self)
        }
        
        self.lineAnimator.startAnimation()
    }
    
    func getFrame(for direction: String, isFinalPosition: Bool = false) -> CGRect?
    {
        guard
            let superView = self.superview,
            let firstBtn = self.firstMatchingBtn,
            let middleBtn = self.middleMatchingBtn
        else
        {
            return nil
        }
        
        var originX : CGFloat = 0
        var originY : CGFloat = 0
        var frameW : CGFloat = 0
        var frameH : CGFloat = 0
        
        switch direction
        {
        case "vertical":
            frameW = superView.frame.width
            frameH = isFinalPosition ? superView.frame.height : 0
            break
        case "horizontal":
            frameW = isFinalPosition ? superView.frame.width : 0
            frameH = superView.frame.height
            break
        default: // diagonal
            frameW = superView.frame.width
            frameH = superView.frame.height
            originX = isFinalPosition ? 0 : -frameW
            originY = isFinalPosition ? 0 : -frameH
            
            if (firstBtn.center.x > middleBtn.center.x) && !isFinalPosition
            {
                originY = frameH
            }
        }
        
        return CGRect(x: originX, y: originY, width: frameW, height: frameH)
    }
}
