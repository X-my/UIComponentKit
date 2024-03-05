//
//  CollectionViewCellComponent.swift
//
//  Created by 许梦阳 on 2023/3/30.
//

import Foundation

/// CollectionViewComponent default cell
open class CollectionViewDefaultCell: UICollectionViewCell {
    public var component: CollectionViewCellComponent?
    
}

open class CollectionViewCellComponent: Component, Statefull, Sizeable {
    
    public typealias View = UICollectionViewCell
    
    /// indexPath for cell component
    public var indexPath: IndexPath = IndexPath(item: 0, section: 0)
    /// 神策埋点是否已经曝光
    public var isAnalyticsExposed = false
    /// 神策曝光埋点回调
    public var analyticsExposeCallback: AnalyticsCallback?
    /// 神策点击埋点回调
    public var analyticsClickCallback: AnalyticsCallback?
    /// 宿主CollectionView
    public weak var hostCollectionView: UICollectionView?
    
    required public override init(_ state: State) {
        super.init(state)
        
        self.buildFlexNode()
    }
    
    open func cellClass() -> AnyClass {
        return CollectionViewDefaultCell.self
    }
    
    /// Function that must be overrided to build cell's root flex node
    open func buildFlexNode() {}
    
    open func didSelect() {}
    
    open func exposeSubViews() -> Array<UIView> { return [] }
    
    open func view() -> UICollectionViewCell? {
        if let sectionComponent = self.parent as? CollectionViewSectionComponent,
            let collectionViewComponent = self.parent?.parent as? CollectionViewComponent,
            let collectionView = collectionViewComponent.view() {
            if let section = collectionViewComponent.children.firstIndex(of: sectionComponent),
                let item = sectionComponent.cells.firstIndex(of: self) {
                let indexPath = IndexPath(item: item, section: section)
                return collectionView.cellForItem(at: indexPath)
            }
        }
        return nil
    }

    open func componentDidUpdate(view: UICollectionViewCell? = nil) {
        
    }
    
    open func componentSize(from state: State) -> CGSize {
        return .zero
    }
}
