//
//  FlexImageView.swift
//  UIComponentKitSwift
//
//  Created by 许梦阳 on 2021/1/21.
//

import Foundation
import Kingfisher

public class FlexImageView: FlexView {
    
    public var image: UIImage?
    public var imageURL: String?
    
    public required init() {
        self.image = nil
        self.imageURL = nil
        
        super.init()
        self.userInteractionEnabled = false
    }
    
    open override func view(from node: FlexNode) -> UICKImageView {
        let imageView = UICKImageView(frame: self.frame)
        imageView.configurate(with: self)
        imageView.contentMode = self.contentMode
        if let urlStr = self.imageURL, let imageURL = URL(string: urlStr) {
            imageView.kf.setImage(with: imageURL, placeholder: image)
        } else {
            imageView.image = self.image
        }
        return imageView
    }
    
}

public class UICKImageView: UIImageView {
    
}
