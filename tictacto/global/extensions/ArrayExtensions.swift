//
//  ArrayExtensions.swift
//  tictacto
//
//  Created by Brad Phillips on 11/16/18.
//  Copyright © 2018 megaBreezy. All rights reserved.
//

import Foundation

extension Array
{
    var middle: Element?
    {
        guard
            count != 0
        else
        {
            return nil
        }
        
        let middleIndex = (count > 1 ? count - 1 : count) / 2
        return self[middleIndex]
    }
    
}
