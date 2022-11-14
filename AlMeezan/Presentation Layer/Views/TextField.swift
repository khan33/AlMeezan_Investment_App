//
//  TextField.swift
//  AlMeezan
//
//  Created by Atta khan on 30/08/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class TextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: 12, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: 12, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: 12, dy: 0)
    }
}
