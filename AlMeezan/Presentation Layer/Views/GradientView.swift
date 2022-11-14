//
//  GradientView.swift
//  AlMeezan
//
//  Created by Atta khan on 13/01/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {

    @IBInspectable var startColor: UIColor = .blue {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var endColor: UIColor = .green {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowColor1: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowY: CGFloat = -3 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowBlur: CGFloat = 3 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var startPointY: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var endPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var endPointY: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

//    @IBInspectable var cornerRadius: CGFloat = 0 {
//        didSet {
//            setNeedsLayout()
//        }
//    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor1.cgColor
        layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
        layer.shadowRadius = shadowBlur
        layer.shadowOpacity = 1
    }
}
