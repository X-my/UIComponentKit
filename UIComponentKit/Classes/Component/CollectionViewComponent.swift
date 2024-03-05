//
//  CollectionViewComponent.swift
//
//  Created by 许梦阳 on 2023/3/30.
//

import UIKit

class CollectionView: UICollectionView, UIGestureRecognizerDelegate {
    var shouldRecognizeOtherGesturer = false
    weak var component: CollectionViewComponent?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.panGestureRecognizer.delegate = self
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let _ = gestureRecognizer.view as? UIScrollView else {
            return false
        }
        return shouldRecognizeOtherGesturer
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let previousTraitCollection = previousTraitCollection else { return }
        if previousTraitCollection.horizontalSizeClass != traitCollection.horizontalSizeClass || previousTraitCollection.verticalSizeClass != traitCollection.verticalSizeClass {
            indexPathsForVisibleItems.forEach {
                if let cell = component?.cellComponent(from: $0) {
                    cell.buildFlexNode()
                }
            }
            reloadData()
        }
    }
}

public typealias AnalyticsCallback = (State, IndexPath) -> ()

open class CollectionViewComponent: Component, Statefull, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public typealias View = UICollectionView
    
    private var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    private var cellClasses: Array<String>
    private let _collectionView: CollectionView
    
    public var collectionView: UICollectionView {
        return _collectionView
    }
    // https://www.jianshu.com/p/e26d6aec167d
    public var didSelectItemAt: (IndexPath, CollectionViewCellComponent) -> Void = { (indexPath, cellComponent) in }
    public var willEndDragging: (UIScrollView, CGPoint, UnsafeMutablePointer<CGPoint>) -> Void = { _,_,_ in }
    public var didEndDragging: (UIScrollView, Bool) -> Void = { (scrollerView, false) in }
    public var didEndDecelerating: (UIScrollView) -> Void = { (scrollerView) in }
    public var willBeginDragging: (UIScrollView) -> Void = { (scrollerView) in }
    public var didScroll: (UIScrollView) -> Void = { (scrollerView) in }
    public var didEndScrollingAnimation: (UIScrollView) -> Void = { (scrollerView) in }
    public var shouldScrollToTop: (UIScrollView) -> Bool = { (scrollerView) in return true }
    
    public convenience init() {
        self.init(State(nil))
    }
    
    public override init(_ state: State) {
        cellClasses = []
        
        layout = UICollectionViewFlowLayout.init()
        if let attributes = state.attributes {
            if let flowLayout = attributes["layout"] as? UICollectionViewFlowLayout {
                layout = flowLayout
            }
            if let direction = attributes["direction"] as? UICollectionView.ScrollDirection {
                layout.scrollDirection = direction
            } else {
                layout.scrollDirection = UICollectionView.ScrollDirection.vertical
            }
            if let sectionHeadersPinToVisibleBounds = attributes["sectionHeadersPinToVisibleBounds"] as? Bool {
                layout.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds
            } else {
                layout.sectionHeadersPinToVisibleBounds = false
            }
        }
        _collectionView = CollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 1), collectionViewLayout: layout)
        
        super.init(state)
        
        _collectionView.component = self
        _collectionView.dataSource = self
        _collectionView.delegate = self
        _collectionView.backgroundColor = UIColor.white
        if #available(iOS 10.0, *) {
            _collectionView.isPrefetchingEnabled = false
        }
        if let attributes = state.attributes {
            if let bounces = attributes["bounces"] as? Bool {
                _collectionView.bounces = bounces
            }
            if let pagingEnabled = attributes["pagingEnabled"] as? Bool {
                _collectionView.isPagingEnabled = pagingEnabled
            }
            if let showsHorizontalScrollIndicator = attributes["showsHorizontalScrollIndicator"] as? Bool {
                _collectionView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
            }
            if let showsVerticalScrollIndicator = attributes["showsVerticalScrollIndicator"] as? Bool {
                _collectionView.showsVerticalScrollIndicator = showsVerticalScrollIndicator
            }
            /// 响应多手势
            if let shouldRecognizeOtherGesturer = attributes["shouldRecognizeOtherGesturer"] as? Bool {
                _collectionView.shouldRecognizeOtherGesturer = shouldRecognizeOtherGesturer
            }
        }
        
        _collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
    }
    
    public func view() -> UICollectionView? {
        return _collectionView
    }
    
    public func componentDidUpdate(view: UICollectionView? = nil) {
        _collectionView.reloadData()
    }
    
    open override func childComponentDidUpdate(child: Component) {
        if let section = child as? CollectionViewSectionComponent {
            for childComponent in section.children {
                registerComponent(component: childComponent)
            }
            let ip = indexPath(from: section)
            if let indexPath = ip {
                if indexPath.section < children.count {
                    if let animationsEnabled = child.state.attributes?["animationsEnabled"] as? Bool {
                        UIView.setAnimationsEnabled(animationsEnabled)
                        _collectionView.performBatchUpdates({
                            _collectionView.reloadSections(IndexSet(integer: indexPath.section))
                        }) { (finished) in
                            UIView.setAnimationsEnabled(true)
                        }
                    } else {
                        UIView.setAnimationsEnabled(false)
                        _collectionView.performBatchUpdates({
                            _collectionView.reloadSections(IndexSet(integer: indexPath.section))
                        }) { (finished) in
                            UIView.setAnimationsEnabled(true)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: API Methods
    
    /// Add a cell component with a new section. This method will create a new `SectionComponent` as the parent component of added childComponent
    ///
    /// - Parameter childComponent: cell component
    open override func add(childComponent: Component) {
        if let cellComponent = childComponent as? CollectionViewCellComponent {
            let state = State([cellComponent.state.value])
            let sectionComponent = CollectionViewSectionComponent(state)
            sectionComponent.section = children.count
            
            sectionComponent.add(childComponent: cellComponent)
            registerComponent(component: cellComponent)
            
            super.add(childComponent: sectionComponent)
        }
    }
    
    /// Add a cell component to last section. if there is no section, that will create a new `SectionComponent` as the parent component of added childComponent
    ///
    /// - Parameter cellComponent: cell component
    open func add(cellComponent: CollectionViewCellComponent) {
        if let lastSection = children.reversed().filter({ $0 is CollectionViewSectionComponent }).first as? CollectionViewSectionComponent {
            lastSection.add(childComponent: cellComponent)
            registerComponent(component: cellComponent)
        }else {
            let sectionComponent = CollectionViewSectionComponent(State(nil))
            sectionComponent.add(childComponent: cellComponent)
            add(sectionComponent: sectionComponent)
        }
    }
    
    /// Add a section component with a new section
    ///
    /// - Parameter sectionComponent: section component
    open func add(sectionComponent: CollectionViewSectionComponent) {
        sectionComponent.section = children.count
        for childComponent in sectionComponent.children {
            registerComponent(component: childComponent)
        }
        super.add(childComponent: sectionComponent)
    }
    
    public override func clear() {
        self.cellClasses = []
        super.clear()
    }
    
    public func clear(sectionComponent: CollectionViewSectionComponent) {
        var removedIndex = -1
        for index in 0...children.count-1 {
            let child = children[index]
            if let section = child as? CollectionViewSectionComponent {
                if section.sectionId == sectionComponent.sectionId {
                    removedIndex = index
                    break
                }
            }
        }
        if removedIndex > 0 {
            children.remove(at: removedIndex)
        }
    }
    
    /// Invalidates current layout of the collectionView and triggers a layout update.
    open func invalidateLayout() {
        view()?.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: UICollectionView
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.children.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let component = self.children[section]
        if let sectionComponent = component as? CollectionViewSectionComponent {
            return sectionComponent.cells.count
        } else {
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let sectionComponent = children[indexPath.section] as? CollectionViewSectionComponent {
            let cellComponent = sectionComponent.cells[indexPath.item]
            cellComponent.indexPath = indexPath
            cellComponent.hostCollectionView = collectionView
            if !cellComponent.isAnalyticsExposed {
                cellComponent.analyticsExposeCallback?(cellComponent.state, indexPath)
                cellComponent.isAnalyticsExposed = true
            }
            let identifier = String(describing: type(of: cellComponent))
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
            
            if let defaultCell = cell as? CollectionViewDefaultCell {
                defaultCell.component = cellComponent
                for subview in defaultCell.contentView.subviews {
                    subview.removeFromSuperview()
                }
                cellComponent.componentDidUpdate(view: defaultCell)
                
                return defaultCell
            } else {
                for subview in cell.contentView.subviews {
                    subview.removeFromSuperview()
                }
                cellComponent.componentDidUpdate(view: cell)
                
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionComponent = children[indexPath.section] as? CollectionViewSectionComponent {
            if kind == UICollectionView.elementKindSectionHeader {
                if let headerComponent = sectionComponent.header {
                    if !headerComponent.isAnalyticsExposed {
                        headerComponent.analyticsExposeCallback?(headerComponent.state, indexPath)
                        headerComponent.isAnalyticsExposed = true
                    }
                    let identifier = String(describing: type(of: headerComponent))
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
                    if let defaultHeaderView = headerView as? CollectionReusableView {
                        defaultHeaderView.component = headerComponent
                        for subview in defaultHeaderView.subviews {
                            subview.removeFromSuperview()
                        }
                    }
                    headerComponent.componentDidUpdate(view: headerView)
                    
                    return headerView
                } else {
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DefaultHeader", for: indexPath)
                    return headerView
                }
            } else {
                if let footerComponent = sectionComponent.footer {
                    if !footerComponent.isAnalyticsExposed {
                        footerComponent.analyticsExposeCallback?(footerComponent.state, indexPath)
                        footerComponent.isAnalyticsExposed = true
                    }
                    let identifier = String(describing: type(of: footerComponent))
                    let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
                    if let defaultFooterView = footerView as? CollectionReusableView {
                        defaultFooterView.component = footerComponent
                        for subview in defaultFooterView.subviews {
                            subview.removeFromSuperview()
                        }
                    }
                    footerComponent.componentDidUpdate(view: footerView)
                    
                    return footerView
                } else {
                    let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DefaultFooter", for: indexPath)
                    return footerView
                }
            }
        } else {
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DefaultHeader", for: indexPath)
                return headerView
            } else {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DefaultFooter", for: indexPath)
                return footerView
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.section < children.count,
              let sectionComponent = children[indexPath.section] as? CollectionViewSectionComponent,
              indexPath.item < sectionComponent.cells.count else {
            return .zero
        }
        let cellComponent = sectionComponent.cells[indexPath.item]
        return cellComponent.componentSize(from: cellComponent.state)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let sectionComponent = children[section] as? CollectionViewSectionComponent, let headerComponent = sectionComponent.header {
            return headerComponent.componentSize(from: headerComponent.state)
        }
        return CGSize.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let sectionComponent = children[section] as? CollectionViewSectionComponent, let footerComponent = sectionComponent.footer {
            return footerComponent.componentSize(from: footerComponent.state)
        }
        return CGSize.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let sectionComponent = children[section] as? CollectionViewSectionComponent {
            return sectionComponent.minimumLineSpacing
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let sectionComponent = children[section] as? CollectionViewSectionComponent {
            return sectionComponent.minimumInteritemSpacing
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let sectionComponent = children[section] as? CollectionViewSectionComponent {
            return sectionComponent.inset
        }
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = cellComponent(from: indexPath) {
            cell.analyticsClickCallback?(cell.state, indexPath)
            didSelectItemAt(indexPath, cell)
            cell.didSelect()
        }
    }
    
    // MARK: UIScrollViewDelegate
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didEndDragging(scrollView, decelerate)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndDecelerating(scrollView)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        willBeginDragging(scrollView)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        didEndScrollingAnimation(scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        willEndDragging(scrollView, velocity, targetContentOffset)
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return shouldScrollToTop(scrollView)
    }
    
    public func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        _collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    // MARK: Helper Methods
    open func cellComponentDidUpdate(cell: CollectionViewCellComponent) {
        let ip = indexPath(from: cell)
        if let indexPath = ip, let section = cell.parent as? CollectionViewSectionComponent {
            if indexPath.section < children.count && indexPath.item < section.cells.count {
                if let animationsEnabled = cell.state.attributes?["animationsEnabled"] as? Bool {
                    UIView.setAnimationsEnabled(animationsEnabled)
                    _collectionView.performBatchUpdates({
                        _collectionView.reloadItems(at: [indexPath])
                    }) { (finished) in
                        UIView.setAnimationsEnabled(true)
                    }
                } else {
                    UIView.setAnimationsEnabled(false)
                    _collectionView.performBatchUpdates({
                        _collectionView.reloadItems(at: [indexPath])
                    }) { (finished) in
                        UIView.setAnimationsEnabled(true)
                    }
                }
            }
        }
    }
    
    open func reusableViewComponentDidUpdate(reusableView: CollectionViewReusableViewComponent, scrollToTop: Bool = false) {
        if reusableView.section < children.count {
            let indexPath = IndexPath(item: 0, section: reusableView.section)
            UIView.setAnimationsEnabled(false)
            _collectionView.performBatchUpdates({
                _collectionView.reloadSections(IndexSet(integer: indexPath.section))
            }) { (finished) in
                if scrollToTop == true {
                    self._collectionView.setContentOffset(.zero, animated: false)
                }
                UIView.setAnimationsEnabled(true)
            }
        }
    }
    
    func cellComponent(from indexPath: IndexPath) -> CollectionViewCellComponent? {
        if indexPath.section < children.count {
            if let section = children[indexPath.section] as? CollectionViewSectionComponent {
                if indexPath.item < section.children.count {
                    let cell = section.cells[indexPath.item]
                    return cell
                }
            }
        }
        return nil
    }
    
    public func indexPath(from sectionComponent: CollectionViewSectionComponent) -> IndexPath? {
        var indexPath: IndexPath?
        if children.firstIndex(of: sectionComponent) != nil {
            indexPath = IndexPath(item: 0, section: children.firstIndex(of: sectionComponent)!)
        }
        return indexPath
    }
    
    public func indexPath(from cellComponent: CollectionViewCellComponent) -> IndexPath? {
        var indexPath: IndexPath?
        for index in 0...children.count-1 {
            let child = children[index]
            if let section = child as? CollectionViewSectionComponent {
                if section.cells.firstIndex(of: cellComponent) != nil {
                    indexPath = IndexPath(item: section.cells.firstIndex(of: cellComponent)!, section: index)
                    break
                }
            }
        }
        return indexPath
    }
    
    public func registerComponent(component: Component) {
        let operation = {
            let identifier = String(describing: type(of: component))
            if let cellComponent = component as? CollectionViewCellComponent {
                if !self.cellClasses.contains(identifier) {
                    self._collectionView.register(cellComponent.cellClass(), forCellWithReuseIdentifier: identifier)
                    self.cellClasses.append(identifier)
                }
            } else if let reusableViewComponent = component as? CollectionViewReusableViewComponent {
                switch reusableViewComponent.viewType() {
                case .ReusableViewHeader:
                    if !self.cellClasses.contains(identifier) {
                        self._collectionView.register(reusableViewComponent.viewClass(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
                        self.cellClasses.append(identifier)
                    }
                    break;
                case .ReusableViewFooter:
                    if !self.cellClasses.contains(identifier) {
                        self._collectionView.register(reusableViewComponent.viewClass(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
                        self.cellClasses.append(identifier)
                    }
                    break;
                }
            }
        }
        if Thread.current.isMainThread {
            operation()
        } else {
            DispatchQueue.main.sync {
                operation()
            }
        }
    }
}
