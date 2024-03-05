//
//  FlexBoxSizeAdaptive.swift
//  UIComponentKitSwift
//
//  Created by 许梦阳 on 2021/1/21.
//

import Foundation

public protocol FlexBoxSizeAdaptive {
    
    func sizeThatFits(_ size: CGSize) -> CGSize
    
}

