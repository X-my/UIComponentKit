//
//  FlexTextView.swift
//  UIComponentKitSwift
//
//  Created by 许梦阳 on 2021/1/21.
//

import Foundation

public class FlexTextView: FlexView, UITextViewDelegate, FlexBoxSizeAdaptive {
    /// The current styled text that is displayed by the textView. default is nil
    public var attributedText: NSAttributedString?
    
    public var isScrollEnabled: Bool = false
    
    public var isSelectable: Bool = true
    
    public var shouldHighlightLink = false
    
    public var linkInteractHandler: ((URL) -> ())?
    
    public var linkTextColor: UIColor?
    
    private static let sizeCalculationTextView = UITextView()

    
    open override func view(from node: FlexNode) -> UICKTextView {
        let textView = UICKTextView(frame: self.frame)
        textView.configurate(with: self)
        textView.attributedText = attributedText
        textView.isEditable = false
        textView.delegate = self
        textView.isScrollEnabled = isScrollEnabled
        textView.textContainerInset = .zero
        textView.isUserInteractionEnabled = true
        textView.isSelectable = isSelectable
        textView.clipsToBounds = true
        if shouldHighlightLink {
            textView.dataDetectorTypes = .link
            if let linkColor = linkTextColor {
                textView.linkTextAttributes = [
                    NSAttributedString.Key.foregroundColor : linkColor,
                ]
            }
        }
        return textView
    }
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        linkInteractHandler?(URL)
        return false
    }
    
    // MARK: - FlexSizeAdaptive
    
    public func sizeThatFits(_ size: CGSize) -> CGSize {
        let view = FlexTextView.sizeCalculationTextView
        view.attributedText = attributedText
        view.textContainerInset = .zero
        return view.sizeThatFits(size)
    }
    
}

public class UICKTextView: UITextView {
    
}
