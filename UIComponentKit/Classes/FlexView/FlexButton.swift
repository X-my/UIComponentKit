//
//  FlexButton.swift
//  UIComponentKitSwift
//
//  Created by 许梦阳 on 2021/1/21.
//

import Foundation
import Kingfisher

public class FlexButton: FlexView {
    public var title: String?
    public var titleSelected: String?
    public var titleColor: UIColor
    public var titleColorSelected: UIColor?
    public var image: UIImage?
    public var imageSelected: UIImage?
    public var backgroundImage: UIImage?
    public var attributedTitle: NSAttributedString?
    public var attributedTitleSelected: NSAttributedString?
    public var imageURL: String?
    public var titleLabelFont: UIFont?
    public var imageEdgeInsets: UIEdgeInsets
    public var titleEdgeInsets: UIEdgeInsets
    
    public required init() {
        self.title = nil
        self.titleSelected = nil
        self.titleColor = UIColor.black
        self.titleColorSelected = nil
        self.image = nil
        self.imageSelected = nil
        self.backgroundImage = nil
        self.attributedTitle = nil
        self.imageURL = nil
        self.imageEdgeInsets = .zero
        self.titleEdgeInsets = .zero
        super.init()
        self.userInteractionEnabled = true
    }
    
    open override func view(from node: FlexNode) -> UICKButton {
        let button = UICKButton(frame: self.frame)
        button.configurate(with: self)
        if let font = titleLabelFont {
            button.titleLabel?.font = font
        }
        if let buttonTitle = title {
            button.setTitle(buttonTitle, for: UIControl.State.normal)
        }
        if let buttonTitleSelected = titleSelected {
            button.setTitle(buttonTitleSelected, for: UIControl.State.selected)
        }
        if let buttonTitleColorSelected = titleColorSelected {
            button.setTitleColor(buttonTitleColorSelected, for: UIControl.State.selected)
        }
        if let buttonImage = image {
            button.setImage(buttonImage, for: UIControl.State.normal)
        }
        if let buttonImageSelected = imageSelected {
            button.setImage(buttonImageSelected, for: UIControl.State.selected)
        }
        if let attributedTitle = attributedTitle {
            button.setAttributedTitle(attributedTitle, for: .normal)
        }
        if let attributedTitleSelected = attributedTitleSelected {
            button.setAttributedTitle(attributedTitleSelected, for: .selected)
        }
        button.setTitleColor(titleColor, for: UIControl.State.normal)
        if let imageURLStr = imageURL, let imageURL = URL(string: imageURLStr) {
            button.kf.setImage(with: imageURL, for: .normal)
        } else if self.image != nil {
            button.setImage(self.image, for: UIControl.State.normal)
        }
        button.imageEdgeInsets = imageEdgeInsets
        button.titleEdgeInsets = titleEdgeInsets
        return button
    }
    
}

public class UICKButton: UIButton {
    
}
