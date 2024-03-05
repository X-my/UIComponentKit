//
//  FlexConfig+Enums.swift
//  UIComponentKit
//
//  Created by 许梦阳 on 2023/4/2.
//

import Foundation
import yoga

extension FlexConfig.FlexDirection {
    var yogaValue: YGFlexDirection {
        switch self {
        case .column:        return YGFlexDirection.column
        case .columnReverse: return YGFlexDirection.columnReverse
        case .row:           return YGFlexDirection.row
        case .rowReverse:    return YGFlexDirection.rowReverse
        }
    }
}

extension FlexConfig.JustifyContent {
    var yogaValue: YGJustify {
        switch self {
        case .start:        return YGJustify.flexStart
        case .center:       return YGJustify.center
        case .end:          return YGJustify.flexEnd
        case .spaceBetween: return YGJustify.spaceBetween
        case .spaceAround:  return YGJustify.spaceAround
        case .spaceEvenly:  return YGJustify.spaceEvenly
        }
    }
}

extension FlexConfig.AlignContent {
    var yogaValue: YGAlign {
        switch self {
        case .stretch:      return YGAlign.stretch
        case .start:        return YGAlign.flexStart
        case .center:       return YGAlign.center
        case .end:          return YGAlign.flexEnd
        case .spaceBetween: return YGAlign.spaceBetween
        case .spaceAround:  return YGAlign.spaceAround
        }
    }
}

extension FlexConfig.AlignItems {
    var yogaValue: YGAlign {
        switch self {
        case .stretch:      return YGAlign.stretch
        case .start:        return YGAlign.flexStart
        case .center:       return YGAlign.center
        case .end:          return YGAlign.flexEnd
        case .baseline:     return YGAlign.baseline
        }
    }
}

extension FlexConfig.AlignSelf {
    var yogaValue: YGAlign {
        switch self {
        case .auto:         return YGAlign.auto
        case .stretch:      return YGAlign.stretch
        case .start:        return YGAlign.flexStart
        case .center:       return YGAlign.center
        case .end:          return YGAlign.flexEnd
        case .baseline:     return YGAlign.baseline
        }
    }
}

extension FlexConfig.Wrap {
    var yogaValue: YGWrap {
        switch self {
        case .noWrap:      return YGWrap.noWrap
        case .wrap:        return YGWrap.wrap
        case .wrapReverse: return YGWrap.wrapReverse
        }
    }
}

extension FlexConfig.Position {
    var yogaValue: YGPositionType {
        switch self {
        case .relative: return YGPositionType.relative
        case .absolute: return YGPositionType.absolute
        }
    }
}
