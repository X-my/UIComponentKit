//
//  Extensions.swift
//  UIComponentKitSwift
//
//  Created by 许梦阳 on 2022/9/21.
//

import UIKit

extension UIView {
    
    typealias FlexGestureHandler = () -> Void
    
    private struct AssociatedKeys {
        static var tapGestureKey = "flex_tapGesture"
        static var tapGestureHandlerKey = "flex_tapGestureHandler"
        static var longPressGestureKey = "flex_longPressGesture"
        static var longPressGestureHandlerKey = "flex_longPressGestureHandler"
        static var shouldProtectMultipleClicksKey = "flex_shouldProtectMultipleClicks"
        static var lastClickTime = "flex_lastClickTime"
    }
    
    // 防重复点击，默认false
    var shouldProtectMultipleClicks: Bool {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.shouldProtectMultipleClicksKey) as? NSNumber)?.boolValue ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.shouldProtectMultipleClicksKey, NSNumber(booleanLiteral: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var lastClickTime: TimeInterval {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.shouldProtectMultipleClicksKey) as? NSNumber)?.doubleValue ?? 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.shouldProtectMultipleClicksKey, NSNumber(floatLiteral: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: - Tap Gesture
    
    func setTapGestureHandler(_ handler: (() -> Void)?) {
        if let oldGesture = flex_tapGesture {
            removeGestureRecognizer(oldGesture)
        }
        if handler != nil {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(flex_handleTapGesture(_:)))
            addGestureRecognizer(tapGesture)
            flex_tapGesture = tapGesture
            isUserInteractionEnabled = true
        }
        flex_tapGestureHandler = handler
    }
    
    private var flex_tapGesture: UITapGestureRecognizer? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tapGestureKey) as? UITapGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tapGestureKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var flex_tapGestureHandler: FlexGestureHandler? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tapGestureHandlerKey) as? FlexGestureHandler
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tapGestureHandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func flex_handleTapGesture(_ recognizer: UIGestureRecognizer) {
        guard recognizer.state == .recognized else {
            return
        }
        if shouldProtectMultipleClicks, lastClickTime > 0 {
            let current = Date().timeIntervalSince1970
            if current - lastClickTime > 1 {
                lastClickTime = current
                flex_tapGestureHandler?()
            } else {
                debugPrint("UIComponent multiple clicks protected")
            }
        } else {
            flex_tapGestureHandler?()
        }
    }
    
    // MARK: - Long Press Gesture
    
    func setLongPressGestureHandler(_ handler: (() -> Void)?) {
        if let oldGesture = flex_longPressGesture {
            removeGestureRecognizer(oldGesture)
        }
        if handler != nil {
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(flex_handleLongPressGesture(_:)))
            addGestureRecognizer(longPressGesture)
            flex_longPressGesture = longPressGesture
            isUserInteractionEnabled = true
        }
        flex_longPressGestureHandler = handler
    }
    
    private var flex_longPressGesture: UILongPressGestureRecognizer? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.longPressGestureKey) as? UILongPressGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.longPressGestureKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var flex_longPressGestureHandler: FlexGestureHandler? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.longPressGestureHandlerKey) as? FlexGestureHandler
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.longPressGestureHandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func flex_handleLongPressGesture(_ recognizer: UIGestureRecognizer) {
        flex_longPressGestureHandler?()
    }
    
}
