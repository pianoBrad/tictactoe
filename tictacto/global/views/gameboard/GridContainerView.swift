//
//  GridContainerView.swift
//  tictacto
//
//  Created by Brad Phillips on 11/17/18.
//  Copyright © 2018 megaBreezy. All rights reserved.
//

import UIKit

class GridContainerView: UIView
{
    /** Custom methods **/
    func disappear()
    {
        self.alpha = 0
    }
    
    func reappear()
    {
        self.alpha = 1
    }
}
