//
//  BarButtonItemWithBlock.swift
//  Brother Print SDK Demo
//
//  Created by matsuo yu on 2024/04/01.
//

import UIKit

class BarButtonItemWithBlock: UIBarButtonItem {
    private var actionBlock: ((UIBarButtonItem) -> Void)?
    
    convenience init(title: String?, style: UIBarButtonItem.Style, block: @escaping ((UIBarButtonItem) -> Void)) {
        self.init(title: title, style: style, target: nil, action: #selector(pushed))
        self.target = self
        self.actionBlock = block
    }
    
    @objc func pushed(sender: UIBarButtonItem) {
        actionBlock?(sender)
    }
}
