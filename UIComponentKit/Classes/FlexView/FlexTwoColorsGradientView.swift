//
//  FlexTwoColorsGradientView.swift
//  UIComponentKitSwift
//
//  Created by 许梦阳 on 2022/5/23.
//

import UIKit

public class FlexTwoColorsGradientView: FlexView {
    public var startColor: UIColor?
    public var endColor: UIColor?
    public var isVetical = false
    
    override public func view(from node: FlexNode) -> UIView {
        let view = super.view(from: node)
        if let startColor = startColor, let endColor = endColor {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.bounds
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            gradientLayer.locations =  [NSNumber(value: 0), NSNumber(value: 1)]
            gradientLayer.startPoint = .zero
            gradientLayer.endPoint = isVetical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
            view.layer.addSublayer(gradientLayer)
        }
        return view
    }
}
