//
//  ButtonView.swift
//  AlMeezan
//
//  Created by Atta khan on 27/12/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
import UIKit

class CommonButton {
    struct ButtonModel {
        var title: String
    }
    
    var model: ButtonModel? {
        didSet {
            applyContent()
        }
    }
    
    
    private var button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    func applyContent() {
        guard let title = model?.title else { return }
        button.setTitle(title, for: .normal)
    }
    init() {
        // setup button layout & constraints
    }
}
