//
//  FlexConfig.swift
//  UIComponentKit
//
//  Created by 许梦阳 on 2023/4/2.
//

import Foundation
import yoga

public struct FlexConfig {

    /**
     */
    public enum FlexDirection {
        /// Default value. The flexible items are displayed vertically, as a column.
        case column
        /// Same as column, but in reverse order
        case columnReverse
        /// The flexible items are displayed horizontally, as a row.
        case row
        /// Same as row, but in reverse order
        case rowReverse
    }

    /**
     */
    public enum JustifyContent {
        /// Default value. Items are positioned at the beginning of the container.
        case start
        /// Items are positioned at the center of the container
        case center
        /// Items are positioned at the end of the container
        case end
        /// Items are positioned with space between the lines
        case spaceBetween
        /// Items are positioned with space before, between, and after the lines
        case spaceAround
        /// Items are positioned with space distributed evenly, items have equal space around them.
        case spaceEvenly
    }

    /**
     */
    public enum AlignContent {
        /// Default value. Lines stretch to take up the remaining space
        case stretch
        /// Lines are packed toward the start of the flex container
        case start
        /// Lines are packed toward the center of the flex container
        case center
        /// Lines are packed toward the end of the flex container
        case end
        /// Lines are evenly distributed in the flex container
        case spaceBetween
        /// Lines are evenly distributed in the flex container, with half-size spaces on either end    Play it »
        case spaceAround
    }

    /**
     */
    public enum AlignItems {
        /// Default. Items are stretched to fit the container
        case stretch
        /// Items are positioned at the beginning of the container
        case start
        /// Items are positioned at the center of the container
        case center
        /// Items are positioned at the end of the container
        case end
        /// Items are positioned at the baseline of the container
        case baseline
    }

    /**
     */
    public enum AlignSelf {
        /// Default. The element inherits its parent container's align-items property, or "stretch" if it has no parent container
        case auto
        /// The element is positioned to fit the container
        case stretch
        /// The element is positioned at the beginning of the container
        case start
        /// The element is positioned at the center of the container
        case center
        /// The element is positioned at the end of the container
        case end
        /// The element is positioned at the baseline of the container
        case baseline
    }

    /**
     */
    public enum Wrap {
        /// Default value. Specifies that the flexible items will not wrap
        case noWrap
        /// Specifies that the flexible items will wrap if necessary
        case wrap
        /// Specifies that the flexible items will wrap, if necessary, in reverse order
        case wrapReverse
    }

    /**
     */
    public enum Position {
        /// Default value.
        case relative
        /// Positioned absolutely in regards to its container. The item is positionned using properties top, bottom, left, right, start, end.
        case absolute
    }
    
    public var flexDirection: FlexDirection = .column
    public var justifyContent: JustifyContent = .start
    public var alignContent: AlignContent = .start
    public var alignItems: AlignContent = .stretch
    public var alignSelf: AlignSelf = .auto
    public var position: Position = .relative
    public var flexWrap: Wrap = .noWrap
    public var flexGrow: CGFloat = 0
    public var flexShrink: CGFloat = 0
    
    public var padding: UIEdgeInsets = .zero
    public var margin: UIEdgeInsets = .zero
    
    public var left: CGFloat?
    public var right: CGFloat?
    public var top: CGFloat?
    public var bottom: CGFloat?
    
    /// nil means auto
    public var width: CGFloat?
    /// nil means auto
    public var height: CGFloat?
    /// nil means undefined
    public var minWidth: CGFloat?
    /// nil means undefined
    public var maxWidth: CGFloat?
    /// nil means undefined
    public var minHeight: CGFloat?
    /// nil means undefined
    public var maxHeight: CGFloat?
    
}

extension FlexConfig {
    
    func configYogaNode(_ yogaNode: YGNodeRef) {
        // flex-direction
        YGNodeStyleSetFlexDirection(yogaNode, flexDirection.yogaValue)
        // justify-content
        YGNodeStyleSetJustifyContent(yogaNode, justifyContent.yogaValue)
        // align-content
        YGNodeStyleSetAlignContent(yogaNode, alignContent.yogaValue)
        // align-items
        YGNodeStyleSetAlignItems(yogaNode, alignItems.yogaValue)
        // align-self
        YGNodeStyleSetAlignSelf(yogaNode, alignSelf.yogaValue)
        // flex-wrap
        YGNodeStyleSetFlexWrap(yogaNode, flexWrap.yogaValue)
        // flex-grow
        YGNodeStyleSetFlexGrow(yogaNode, Float(flexGrow))
        // flex-shrink
        YGNodeStyleSetFlexShrink(yogaNode, Float(flexShrink))
        // padding
        YGNodeStyleSetPositionType(yogaNode, .relative)
        YGNodeStyleSetPadding(yogaNode, .left, Float(padding.left))
        YGNodeStyleSetPadding(yogaNode, .top, Float(padding.top))
        YGNodeStyleSetPadding(yogaNode, .right, Float(padding.right))
        YGNodeStyleSetPadding(yogaNode, .bottom, Float(padding.bottom))
        // margin
        YGNodeStyleSetMargin(yogaNode, .left, Float(margin.left))
        YGNodeStyleSetMargin(yogaNode, .top, Float(margin.top))
        YGNodeStyleSetMargin(yogaNode, .right, Float(margin.right))
        YGNodeStyleSetMargin(yogaNode, .bottom, Float(margin.bottom))
        if position == .absolute {
            // left
            if let left = left {
                YGNodeStyleSetPosition(yogaNode, .left, Float(left))
            }
            // right
            if let right = right {
                YGNodeStyleSetPosition(yogaNode, .right, Float(right))
            }
            // top
            if let top = top {
                YGNodeStyleSetPosition(yogaNode, .top, Float(top))
            }
            // bottom
            if let bottom = bottom {
                YGNodeStyleSetPosition(yogaNode, .bottom, Float(bottom))
            }
        }
        // position
        YGNodeStyleSetPositionType(yogaNode, position.yogaValue)
        // width
        if let width = width {
            YGNodeStyleSetWidth(yogaNode, Float(width))
        } else {
            YGNodeStyleSetWidthAuto(yogaNode)
        }
        // height
        if let height = height {
            YGNodeStyleSetHeight(yogaNode, Float(height))
        } else {
            YGNodeStyleSetHeightAuto(yogaNode)
        }
        // min-width
        if let minWidth = minWidth {
            YGNodeStyleSetMinWidth(yogaNode, Float(minWidth))
        }
        // max-width
        if let maxWidth = maxWidth {
            YGNodeStyleSetMaxWidth(yogaNode, Float(maxWidth))
        }
        // min-height
        if let minHeight = minHeight {
            YGNodeStyleSetMinHeight(yogaNode, Float(minHeight))
        }
        // max-height
        if let maxHeight = maxHeight {
            YGNodeStyleSetMaxHeight(yogaNode, Float(maxHeight))
        }
    }
}
