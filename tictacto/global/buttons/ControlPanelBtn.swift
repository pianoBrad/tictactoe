//
//  ControlPanelBtn.swift
//  tictacto
//
//  Created by Brad Phillips on 10/12/18.
//  Copyright © 2018 megaBreezy. All rights reserved.
//

import UIKit

protocol ControlPanelBtnDelegate : class
{
    func controlBtnPressed(_ sender : ControlPanelBtn)
}

class ControlPanelBtn: UIButton
{
    /** Properties **/
    var bgColor : UIColor = .clear
    weak var btnDelegate : ControlPanelBtnDelegate?
    
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
        self.backgroundColor = bgColor
        self.setTitleColor(UIColor.init(hexFromString: "#26BCAC"), for: .normal)
        
        self.addTarget(self, action: #selector(handleBtnPress), for: .touchUpInside)
    }

    convenience init(frame: CGRect, andColor: UIColor, andText: String)
    {
        self.init(frame: frame)
        self.backgroundColor = bgColor
        // self.titleLabel?.text = andText
        setTitle(andText, for: .normal)
    }
    
    @objc func handleBtnPress(_ sender : ControlPanelBtn)
    {
        btnDelegate?.controlBtnPressed(self)
    }
}
