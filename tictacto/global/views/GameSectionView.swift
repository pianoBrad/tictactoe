//
//  GameSectionVIew.swift
//  tictacto
//
//  Created by Brad Phillips on 10/26/18.
//  Copyright © 2018 megaBreezy. All rights reserved.
//

import UIKit

class GameSectionView: UIView
{
    /** Properties **/
    
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
    
    /** Custom methods **/
    func commonInit()
    {
    }
    
    func beginTurn()
    {
    }
    
    func reset()
    {
    }
    
    func endTurn()
    {
    }
    
    func end()
    {
    }
}
