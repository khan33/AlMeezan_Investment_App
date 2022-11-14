//
//  CustomMarkerView.swift
//  AlMeezan
//
//  Created by Atta khan on 29/01/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit
import Charts


class CustomMarkerView: MarkerView {
    @IBOutlet weak var navLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override open func awakeFromNib() {
        self.offset.x = -self.frame.size.width / 2.0
        self.offset.y = -self.frame.size.height - 7.0
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        navLabel?.text = String.init(format: "%.2f", entry.y).toCurrencyFormat(withFraction: true)
        timeLabel?.text = String(entry.x)
        print(String(entry.x))
        layoutIfNeeded()
   }
    
}
