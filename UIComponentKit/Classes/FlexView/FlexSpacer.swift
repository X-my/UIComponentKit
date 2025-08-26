//
//  FlexSpacer.swift
//  UIComponentKit
//
//  Created by xmy on 2025/5/14.
//

import UIKit

public enum FlexSpacerMode {
    case horizontal(CGFloat)
    case vertical(CGFloat)
    case expand
}

public extension FlexNode {
    mutating func spacer(_ mode: FlexSpacerMode) {
        node(from: FlexView.self) {
            switch mode {
            case .horizontal(let size):
                $0.flexConfig.width = size
            case .vertical(let size):
                $0.flexConfig.height = size
            case .expand:
                $0.flexConfig.flexGrow = 1
            }
        }
    }
}

public extension FlexNode.FlexWrapper {
    mutating func spacer(_ mode: FlexSpacerMode) {
        node(from: FlexView.self) {
            switch mode {
            case .horizontal(let size):
                $0.flexConfig.width = size
            case .vertical(let size):
                $0.flexConfig.height = size
            case .expand:
                $0.flexConfig.flexGrow = 1
            }
        }
    }
}
