//
//  FlexActivityIndicatorView.swift
//  UIComponentKitSwift
//
//  Created by 许梦阳 on 2021/12/21.
//

import UIKit

public class FlexActivityIndicatorView: FlexView {
    /// default is gray.
    public var style: UIActivityIndicatorView.Style = .gray
    
    override public func view(from node: FlexNode) -> UIView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.startAnimating()
        let width = max(10, frame.size.width)
        let height = max(10, frame.size.height)
        let scaleX = width / max(indicator.bounds.width, 1)
        let scaleY = height / max(indicator.bounds.height, 1)
        indicator.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        indicator.frame.origin = frame.origin
        return indicator
    }
}
