//
//  FlexAnimatedImageView.swift
//  UIComponentKitSwift
//
//  Created by 许梦阳 on 2021/1/21.
//

import Kingfisher

public class FlexAnimatedImageView: FlexView {
    
    public var imageURL: String?
    public var image: UIImage?
    public var needsPrescaling = false
    
    public required init() {
        self.imageURL = nil
        super.init()
        self.userInteractionEnabled = false
    }
    
    open override func view(from node: FlexNode) -> AnimatedImageView {
        let imageView = AnimatedImageView(frame: self.frame)
        imageView.needsPrescaling = needsPrescaling
        imageView.configurate(with: self)
        imageView.contentMode = self.contentMode
        if let urlStr = imageURL, let imageURL = URL(string: urlStr) {
            imageView.kf.setImage(with: imageURL)
        } else if let image = image {
            imageView.image = image
        }
        return imageView
    }
    
}
