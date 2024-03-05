//
//  UIView+FlexViewConfigurable.swift
//  UIComponentKitSwift
//
//  Created by 许梦阳 on 2023/3/22.
//

import UIKit

extension UIView: FlexViewConfigurable {
    public func configurate(with flexView: FlexView) {
        frame = flexView.frame
        backgroundColor = flexView.backgroundColor
        clipsToBounds = flexView.clipsToBounds
        tag = flexView.tag > 0 ? flexView.tag : 0
        isUserInteractionEnabled = flexView.userInteractionEnabled
        isHidden = flexView.hidden
        alpha = flexView.alpha
        transform = transform
        if let roundingCorners = flexView.roundingCorners {
            let maskPath = UIBezierPath(roundedRect: bounds,
                                        byRoundingCorners: roundingCorners,
                                        cornerRadii: flexView.cornerRadii)
            let maskLayer = CAShapeLayer()
            maskLayer.frame = bounds
            maskLayer.path = maskPath.cgPath
            layer.mask = maskLayer
            if flexView.borderWidth > 0 {
                let borderLayer = CAShapeLayer()
                borderLayer.frame = bounds
                borderLayer.fillColor = UIColor.clear.cgColor
                borderLayer.strokeColor = flexView.borderColor?.cgColor
                borderLayer.lineWidth = flexView.borderWidth
                borderLayer.path = maskPath.cgPath
                layer.insertSublayer(borderLayer, at: 0)
            }
        } else {
            layer.borderWidth = flexView.borderWidth
            layer.borderColor = flexView.borderColor?.cgColor ?? UIColor.clear.cgColor
            layer.cornerRadius = flexView.cornerRadius
        }
        // shadow
        layer.shadowColor = flexView.shadowColor?.cgColor
        layer.shadowOffset = flexView.shadowOffset
        layer.shadowOpacity = Float(flexView.shadowOpacity)
        layer.shadowRadius = flexView.shadowRadius
        if clipsToBounds && flexView.shadowColor != nil && flexView.shadowOpacity > 0 {
            backgroundColor = .clear
            layer.backgroundColor = backgroundColor?.cgColor
            clipsToBounds = false
        }
        
        if flexView.tapGestureHandler != nil {
            isUserInteractionEnabled = true
            setTapGestureHandler(flexView.tapGestureHandler)
        }
        shouldProtectMultipleClicks = shouldProtectMultipleClicks
        if flexView.longPressGestureHandler != nil {
            isUserInteractionEnabled = true
            setLongPressGestureHandler(flexView.longPressGestureHandler)
        }
    }
}
