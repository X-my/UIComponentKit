//
//  FlexLabel.swift
//  UIComponentKitSwift
//
//  Created by 许梦阳 on 2021/1/21.
//

import YYText

open class FlexLabel: FlexView, FlexBoxSizeAdaptive {
    /// The current text that is displayed by the label.
    public var text: String?
    /// The font used to display the text. default is system font 17 plain
    public var font: UIFont!
    /// The color of the text. default is text draws black
    public var textColor: UIColor!
    /// The technique to use for aligning the text. default is NSTextAlignmentNatural (before iOS 9, the default was NSTextAlignmentLeft)
    public var textAlignment: NSTextAlignment
    /// The technique to use for wrapping and truncating the label’s text. default is NSLineBreakByTruncatingTail. used for single and multiple lines of text
    public var lineBreakMode: NSLineBreakMode
    /// The current styled text that is displayed by the label. default is nil
    public var attributedText: NSAttributedString?
    /// The maximum number of lines to use for rendering text. default is 1
    public var numberOfLines: Int = 1
    /// The minimum line height (A wrapper for NSParagraphStyle).
    public var minimumLineHeight: CGFloat?
    /// The maximum line height (A wrapper for NSParagraphStyle).
    public var maximumLineHeight: CGFloat?
    /// The distance in points between the bottom of one line fragment and the top of the next. (A wrapper for NSParagraphStyle)
    public var lineSpacing: CGFloat?
    /// Just like UILabel's
    public var adjustsFontSizeToFitWidth = false
    /// If UIMenuController with copy action can be show when long pressed. default is false
    public var canPerformCopyActionWithLongPress: Bool = false
    
    public required init() {
        text = nil
        font = .systemFont(ofSize: 17)
        textColor = .black
        textAlignment = .natural
        lineBreakMode = .byTruncatingTail
        
        super.init()
        userInteractionEnabled = false
    }
    
    open override func view(from node: FlexNode) -> UIView {
        let label = UICKLabel(frame: frame)
        label.canPerformCopyAction = canPerformCopyActionWithLongPress
        if canPerformCopyActionWithLongPress {
            longPressGestureHandler = { [weak label] in
                label?.becomeFirstResponder()
                let menuController = UIMenuController.shared
                guard let label = label, !menuController.isMenuVisible else {
                    return
                }
                menuController.setTargetRect(label.bounds, in: label)
                menuController.setMenuVisible(true, animated: true)
            }
        }
        label.configurate(with: self)
        label.font = font
        label.textColor = textColor
        configureTextProperties(for: label)
        label.textAlignment = textAlignment
        label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        label.lineBreakMode = lineBreakMode
        return label
    }
    
    // MARK: - Private Methods
    
    private func configureTextProperties(for label: UILabel) {
        label.numberOfLines = numberOfLines
        if attributedText != nil {
            label.attributedText = attributedText
        } else if let text = text {
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.yy_font = font
            attributedText.yy_lineBreakMode = lineBreakMode
            if let minimumLineHeight = minimumLineHeight, minimumLineHeight > 0 {
                attributedText.yy_minimumLineHeight = minimumLineHeight
            }
            if let maximumLineHeight = maximumLineHeight, maximumLineHeight > 0 {
                attributedText.yy_maximumLineHeight = maximumLineHeight
            }
            if let lineSpacing = lineSpacing, lineSpacing > 0 {
                attributedText.yy_lineSpacing = lineSpacing
            }
            label.attributedText = attributedText
        }
    }
    
    // MARK: - FlexSizeAdaptive
    
    public func sizeThatFits(_ size: CGSize) -> CGSize {
        let label = UILabel()
        configureTextProperties(for: label)
        return label.sizeThatFits(size)
    }
    
}

public class UICKLabel: UILabel {
    
    public var canPerformCopyAction: Bool = false
    
    public override var canBecomeFirstResponder: Bool {
        return canPerformCopyAction
    }
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if canPerformCopyAction && action == #selector(copy(_:)) {
            return true
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    public override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
    }
    
}
