//
//  CollectionViewReusableViewComponent.swift
//
//  Created by 许梦阳 on 2023/3/30.
//

import Foundation
import UIKit

public enum ReusableViewType {
    case ReusableViewHeader
    case ReusableViewFooter
}

class CollectionReusableViewLayer: CALayer {
    override init(layer: Any) {
        super.init(layer: layer)
        self.zPosition = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.zPosition = 0
    }
    
    override init() {
        super.init()
        
        self.zPosition = 0
    }
}

/// CollectionViewReusableViewComponent default header or footer view
open class CollectionReusableView: UICollectionReusableView {
    public var component: CollectionViewReusableViewComponent?
    
    override open class var layerClass: AnyClass {
        return CollectionReusableViewLayer.self
    }
    
}

open class CollectionViewReusableViewComponent: Component, Statefull, Sizeable {
    
    public typealias View = UICollectionReusableView
    
    /// 神策埋点是否已经曝光
    public var isAnalyticsExposed = false
    /// 神策曝光埋点回调
    public var analyticsExposeCallback: AnalyticsCallback?
    /// 宿主CollectionView
    public weak var hostCollectionView: UICollectionView?
    /// `indexPath.section` for this ReusableViewComponent
    public var section: Int {
        if let parent = self.parent as? CollectionViewSectionComponent {
            return parent.section
        }
        return 0
    }
    
    public override init(_ state: State) {
        super.init(state)
        
        buildFlexNode()
    }
    
     /// Function that must be overrided to build header's or footer's root flex node
    open func buildFlexNode() {}
    
    open func viewType() -> ReusableViewType {
        return .ReusableViewHeader
    }
    open func viewClass() -> AnyClass {
        return CollectionReusableView.self
    }
    
    open func exposeSubViews() -> Array<UIView> { return [] }
    
    public func view() -> UICollectionReusableView? {
        if let sectionComponent = self.parent as? CollectionViewSectionComponent,
            let collectionViewComponent = self.parent?.parent as? CollectionViewComponent,
            let collectionView = collectionViewComponent.view() {
            if let section = collectionViewComponent.children.firstIndex(of: sectionComponent) {
                let indexPath = IndexPath(item: 0, section: section)
                return collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            }
        }
        return nil
    }
    
    open func componentDidUpdate(view: UICollectionReusableView? = nil) {
        
    }
    
    open func componentSize(from state: State) -> CGSize {
        return .zero
    }
}
