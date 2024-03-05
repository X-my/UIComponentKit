//
//  SingleLabelCellComponent.swift
//  BizVoiceChatRoom
//
//  Created by xmy on 2023/4/17.
//

import Foundation

public final class SingleLabelCellComponent: CollectionViewCellComponent {
    
    public struct Value {
        public var text: NSAttributedString
        public var padding: UIEdgeInsets
        public var textAlignment: NSTextAlignment
        
        public init(text: NSAttributedString, padding: UIEdgeInsets = .zero, textAlignment: NSTextAlignment = .left) {
            self.text = text
            self.padding = padding
            self.textAlignment = textAlignment
        }
    }
    
    private var flexNode: FlexNode?
    
    public override func buildFlexNode() {
        guard let value = state.value as? Value else { return }
        let screenWidth = UIScreen.main.bounds.width
        flexNode = flexRootNode {
            $0.flexConfig.width = screenWidth
            $0.flexConfig.padding = value.padding
            // text
            $0.node(from: FlexLabel.self) {
                $0.flexView.attributedText = value.text
                $0.flexView.textAlignment = value.textAlignment
            }
        }
    }
    
    public override func componentDidUpdate(view: UICollectionViewCell? = nil) {
        guard let flexView = flexNode?.generateUIView() else { return }
        view?.contentView.addSubview(flexView)
    }
    
    public override func componentSize(from state: State) -> CGSize {
        return flexNode?.size() ?? .zero
    }
    
}
