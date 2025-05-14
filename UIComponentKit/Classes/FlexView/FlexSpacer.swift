//
//  FlexSpacer.swift
//  UIComponentKit
//
//  Created by xmy on 2025/5/14.
//

import UIKit

extension FlexNode {
    public mutating func spacer(width: CGFloat = 0, height: CGFloat = 0) -> FlexNode {
        node(from: FlexView.self) {
            $0.flexConfig.width = width
            $0.flexConfig.height = height
        }
    }
}
