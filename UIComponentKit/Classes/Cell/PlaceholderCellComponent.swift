//
//  PlaceholderCellComponent.swift
//  UIComponentKit
//
//  Created by xmy on 2024/5/2.
//

import UIKit

public class PlaceholderCellComponent: CollectionViewCellComponent {
    
    public struct Value {
        public var cellHeight: CGFloat
        public var iconImage: UIImage?
        public var imageSize: CGSize = .zero
        public var text: NSAttributedString?
        public var imageMarginTop: CGFloat
        public var textMarginTop: CGFloat
        
        public init(cellHeight: CGFloat = UIScreen.main.bounds.height,
                    iconImage: UIImage? = nil,
                    imageSize: CGSize,
                    text: NSAttributedString? = nil,
                    imageMarginTop: CGFloat = 100,
                    textMarginTop: CGFloat = 0) {
            self.cellHeight = cellHeight
            self.iconImage = iconImage
            self.imageSize = imageSize
            self.text = text
            self.imageMarginTop = imageMarginTop
            self.textMarginTop = textMarginTop
        }
    }
    
    private var flexNode: FlexNode?
    
    public convenience init(value: Value) {
        self.init(State(value))
    }
    
    public override func buildFlexNode() {
        guard let value = state.value as? Value else { return }
        let screenWidth = UIScreen.main.bounds.width
        flexNode = flexRootNode {
            $0.flexConfig.height = value.cellHeight
            $0.flexConfig.width = screenWidth
            $0.flexConfig.alignItems = .center
            // icon
            $0.node(from: FlexImageView.self) {
                $0.flexConfig.margin.top = value.imageMarginTop
                $0.flexConfig.width = value.imageSize.width
                $0.flexConfig.height = value.imageSize.height
                $0.flexView.contentMode = .scaleAspectFit
                $0.flexView.image = value.iconImage
            }
            // 文字
            if let text = value.text, text.length > 0 {
                $0.node(from: FlexLabel.self) {
                    $0.flexConfig.margin.top = value.textMarginTop
                    $0.flexView.attributedText = value.text
                }
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
