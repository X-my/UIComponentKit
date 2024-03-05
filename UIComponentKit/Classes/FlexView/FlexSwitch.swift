//
//  FlexSwitch.swift
//  UIComponentKit
//
//  Created by xmy on 2023/4/10.
//

import UIKit

public class FlexSwitch: FlexView, FlexBoxSizeAdaptive {

    public var onTintColor: UIColor?
    public var thumbTintColor: UIColor?
    public var onImage: UIImage?
    public var offImage: UIImage?
    public var isOn = true
    
    override public func view(from node: FlexNode) -> UIView {
        let view = super.view(from: node)
        let switchView = UISwitch()
        switchView.onTintColor = onTintColor
        switchView.thumbTintColor = thumbTintColor
        switchView.onImage = onImage
        switchView.offImage = offImage
        switchView.isOn = isOn
        switchView.frame = view.bounds
        switchView.isUserInteractionEnabled = false
        view.addSubview(switchView)
        return view
    }
    
    public func sizeThatFits(_ size: CGSize) -> CGSize {
        return UISwitch().sizeThatFits(size)
    }
}
