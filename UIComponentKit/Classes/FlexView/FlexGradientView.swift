//
//  FlexGradientView.swift
//  UIComponentKitSwift
//
//  Created by 许梦阳 on 2023/3/30.
//

import UIKit

public class FlexGradientView: FlexView {
    public var colors: [UIColor]?
    public var locations: [CGFloat]?
    public var startPoint: CGPoint = .zero
    public var endPoint: CGPoint = .zero
    
    override public func view(from node: FlexNode) -> UIView {
        let view = super.view(from: node)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors?.map { $0.cgColor }
        gradientLayer.locations = locations?.map { NSNumber(floatLiteral: Double($0)) }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        view.layer.addSublayer(gradientLayer)
        return view
    }
}
