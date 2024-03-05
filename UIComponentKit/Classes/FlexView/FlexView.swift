//
//  FlexView.swift
//  UIComponentKitSwift
//
//  Created by 许梦阳 on 2021/1/21.
//

import UIKit

open class FlexView: NSObject {
    public var useASNode = true
    /// The frame rectangle, which describes the view’s location and size in its superview’s coordinate system. default is CGSizeZero
    public var frame: CGRect = CGRect.zero
    /// The view’s background color. default is clear
    public var backgroundColor: UIColor? = UIColor.clear
    /// A Boolean value that determines whether subviews are confined to the bounds of the view. default is false
    public var clipsToBounds: Bool = false
    /// A flag used to determine how a view lays out its content when its bounds change. default is scaleToFill
    public var contentMode: UIView.ContentMode = UIView.ContentMode.scaleToFill
    /// The horizontal alignment of content within the control’s bounds. default is left
    public var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
    /// The vertical alignment of content within the control’s bounds. default is top
    public var contentVerticalAlignment: UIControl.ContentVerticalAlignment = UIControl.ContentVerticalAlignment.top
    /// The corner radius of the view. default is 0.0
    public var cornerRadius: CGFloat = 0.0
    /// The rounds corners of the view.
    public var roundingCorners: UIRectCorner?
    /// The horizontal and vertical radius. Use when roundingCorners is not nil. default is CGSizeZero
    public var cornerRadii: CGSize = .zero
    /// The border color of the view. default is nil
    public var borderColor: UIColor? = .clear
    /// The width of the view's border. default is 0.0
    public var borderWidth: CGFloat = 0.0
    /// The shadow color of the text. default is nil (no shadow)
    public var shadowColor: UIColor?
    /// The shadow offset (measured in points) for the text. default is CGSizeMake(0, -1) -- a top shadow
    public var shadowOffset: CGSize = CGSize(width: 0, height: -1)
    /// The opacity of the shadow. Defaults to 0.
    public var shadowOpacity: CGFloat = 0
    /// The blur radius used to create the shadow. Defaults to 3. Animatable.
    public var shadowRadius: CGFloat = 3
    /// Tag of the view. default is 0
    public var tag: Int = 0
    /// A Boolean value that determines whether user events are ignored. default is true
    public var userInteractionEnabled: Bool = true
    /// A Boolean value that determines whether the view is hidden. default is false
    public var hidden = false
    /// The view’s alpha value. default is 1.0
    public var alpha: CGFloat = 1.0
    /// Tap gesture handler
    public var tapGestureHandler: (() -> Void)?
    /// Long press gesture handler
    public var longPressGestureHandler: (() -> Void)?
    /// default is CGAffineTransformIdentity. animatable. Please use this property instead of the affineTransform property on the layer
    public var transform: CGAffineTransform = .identity
    /// 防重复点击，默认false
    public var shouldProtectMultipleClicks: Bool = false
    
    required public override init() {
        
    }
    
    open func view(from node: FlexNode) -> UIView {
        let view = UICKView(frame: self.frame)
        view.configurate(with: self)
        return view
    }

}


public class UICKView: UIView {
    
}
