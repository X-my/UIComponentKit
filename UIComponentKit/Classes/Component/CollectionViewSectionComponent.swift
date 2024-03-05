//
//  CollectionViewSectionComponent.swift
//
//  Created by 许梦阳 on 2023/3/30.
//

import Foundation

open class CollectionViewSectionComponent: Component, Statefull {
    
    /// `indexPath.section` for this SectionComponent
    public var section: Int = 0
    public var sectionId: Int = 0
    public var cells: Array<CollectionViewCellComponent>
    public var header: CollectionViewReusableViewComponent?
    public var footer: CollectionViewReusableViewComponent?
    public var minimumLineSpacing: CGFloat = 0
    public var minimumInteritemSpacing: CGFloat = 0
    public var inset: UIEdgeInsets = UIEdgeInsets.zero
    
    public init() {
        self.cells = []
        
        super.init(State(nil))
    }
    
    public override init(_ state: State) {
        self.cells = []
        
        super.init(state)
    }
    
    public override func add(childComponent: Component) {
        if let cellComponent = childComponent as? CollectionViewCellComponent {
            cells.append(cellComponent)
        } else if let reusableViewComponent = childComponent as? CollectionViewReusableViewComponent {
            if reusableViewComponent.viewType() == .ReusableViewHeader {
                header = reusableViewComponent
            } else if reusableViewComponent.viewType() == .ReusableViewFooter {
                footer = reusableViewComponent
            }
        }
        super.add(childComponent: childComponent)
    }
    
    /// Insert to the front of the children components
    ///
    /// - Parameter childComponent: child component
    public func push(childComponent: Component) {
        if let cellComponent = childComponent as? CollectionViewCellComponent {
            cells.insert(cellComponent, at: 0)
        }
        super.add(childComponent: childComponent)
    }
    
    public override func clear() {
        self.cells = []
        self.header = nil
        self.footer = nil
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.inset = UIEdgeInsets.zero
        
        if let collectionViewComponent = parent as? CollectionViewComponent {
            collectionViewComponent.clear(sectionComponent: self)
        }
    }
    
    open override func childComponentDidUpdate(child: Component) {
        if let cell = child as? CollectionViewCellComponent, let collectionView = self.parent as? CollectionViewComponent {
            cell.buildFlexNode()
            collectionView.cellComponentDidUpdate(cell: cell)
        } else if let reuableView = child as? CollectionViewReusableViewComponent, let collectionView = self.parent as? CollectionViewComponent {
            reuableView.buildFlexNode()
            if let attributes = state.attributes, let scrollToTop = attributes["scrollToTop"] as? Bool {
                collectionView.reusableViewComponentDidUpdate(reusableView: reuableView, scrollToTop: scrollToTop)
            } else {
                collectionView.reusableViewComponentDidUpdate(reusableView: reuableView, scrollToTop: false)
            }
        }
    }
    
    open func componentDidUpdate(view: UIView?) {
        
    }
    
    
}
