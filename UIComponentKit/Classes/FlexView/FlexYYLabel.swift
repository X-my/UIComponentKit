//
//  FlexYYLabel.swift
//  UIComponentKitSwift
//
//  Created by 许梦阳 on 2021/1/21.
//

import YYText

public class FlexYYLabel: FlexView, FlexBoxSizeAdaptive {
   
    /// The current styled text that is displayed by the label. default is nil
    public var attributedText: NSAttributedString?
    /// The maximum number of lines to use for rendering text. default is 1
    public var numberOfLines: Int = 1
    /// The truncation token string used when text is truncated. Default is nil.
    /// When the value is nil, the label use "…" as default truncation token.
    public var truncationToken: NSAttributedString?
    
    public required init() {
        super.init()
    }
    
    open override func view(from node: FlexNode) -> UIView {
        let label = YYLabel(frame: self.frame)
        label.configurate(with: self)
        label.numberOfLines = UInt(self.numberOfLines)
        label.attributedText = attributedText
        label.truncationToken = truncationToken
        return label
    }
    
    // MARK: - FlexBoxSizeAdaptive
    
    public func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let text = attributedText else { return .zero }
        let container = YYTextContainer()
        container.size = size
        let layout = YYTextLayout(container: container, text: text)
        return layout?.textBoundingSize ?? .zero
    }
}
