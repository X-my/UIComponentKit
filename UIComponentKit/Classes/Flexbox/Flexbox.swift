//
//  Flexbox.swift
//
//  Created by 许梦阳 on 2023/3/30.
//

import UIKit
import yoga

/// Create root node of a flexbox layout
///
/// - Parameter closure: closure that describe the FlexNode instance
/// - Returns: root FlexNode instance
public func flexRootNode(closure: (inout FlexNode) -> Void) -> FlexNode {
    var flexNode = FlexNode()
    flexNode.isRoot = true
    
    closure(&flexNode)
    flexNode.install()
    
    return flexNode
}

/// Node that enables UIKit instances layout with flexbox
public struct FlexNode {
    
    /// flex config to describe the frame of the node
    public var flexConfig: FlexConfig = FlexConfig()
    /// flex view that describes UIView attributes
    public var flexView: FlexView = FlexView()
    /// indicate whether this flexNode is root. default is false
    public var isRoot: Bool = false
    
    private let yogaNodeWrapper: YogaNodeWrapper = .init()
    private var children: Array<FlexNode> = []
    private var nodeSize: CGSize = CGSize.zero
    
    private var yogaNode: YGNodeRef {
        return yogaNodeWrapper.node
    }
    
    private static let globalConfig: YGConfigRef? = {
        let yogaConfig = YGConfigNew()
        YGConfigSetExperimentalFeatureEnabled(yogaConfig, YGExperimentalFeature.webFlexBasis, true)
        YGConfigSetPointScaleFactor(yogaConfig, Float(UIScreen.main.scale))
        return yogaConfig
    }()
    
    private class YogaNodeWrapper {
        
        let node: YGNodeRef = YGNodeNewWithConfig(globalConfig)
        
        deinit {
            YGNodeFree(node)
        }
    }
    
    public init() {

    }
    
    /// Create a node with a specific FlexView type (subclass of FlexView)
    ///
    /// - Parameters:
    ///   - flexViewType: Subclass of FlexView (e.g. FlexLabel.self)
    ///   - closure: closure that describes the FlexWrapper instance `$0`. Using `$0.flexConfig` to setup flexConfig instance, `$0.flexView` to setup flexView instance
    /// - Returns: FlexNode instance
    @discardableResult public mutating func node<T>(from flexViewType: T.Type, closure: (inout FlexWrapper<T>) -> Void) -> FlexNode where T : FlexView {
        var flexWrapper = FlexWrapper(flexView: T())
        
        closure(&flexWrapper)
        
        let flexNode = flexWrapper.node()
        flexNode.install()
        children.append(flexNode)
        
        return flexNode
    }
    
    /// Calculate size of the flex layout
    ///
    /// - Returns: CGSize of the root node
    public mutating func size() -> CGSize {
        calculateRootNodeSize()
        return nodeSize
    }
    
    /// Render view of the flex layout
    ///
    /// - Returns: UIView of the root node
    public mutating func generateUIView() -> UIView {
        calculateRootNodeSize()
        let root = flexView.view(from: self)
        render(childNode: self, rootView: root, parentView: nil)
        return root
    }
    
    /// Return the view associate with the tag assigned in the FlexNode instance
    ///
    /// - Parameter tag: tag associated with the FlexNode
    /// - Returns: an instance of UIView
    public mutating func subview(from rootView: UIView?, with tag: Int) -> UIView? {
        if let view = rootView {
            if tag > 0 {
                return view.viewWithTag(tag)
            }
        }
        return nil
    }
    
    /// FlexNode wrapper which used for closure
    public struct FlexWrapper<T> where T : FlexView {
        public var flexView: T
        public var flexConfig: FlexConfig {
            get {
                return flexNode.flexConfig
            }
            set {
                flexNode.flexConfig = newValue
            }
        }
        
        private var flexNode: FlexNode
        
        init(flexView: T) {
            self.flexView = flexView
            self.flexNode = FlexNode()
        }
        
        /// Create a new child node with a specific FlexView type (subclass of FlexView)
        ///
        /// - Parameters:
        ///   - flexViewType: Subclass of FlexView (e.g. FlexLabel.self)
        ///   - closure: closure that describes the FlexWrapper instance `$0`. Using `$0.flexConfig` to setup flexConfig instance, `$0.flexView` to setup flexView instance
        /// - Returns: FlexNode instance
        @discardableResult public mutating func node<T>(from flexViewType: T.Type, closure: (inout FlexWrapper<T>) -> Void) -> FlexNode where T : FlexView {
            return flexNode.node(from: flexViewType, closure: closure)
        }
        
        func node() -> FlexNode {
            var node = flexNode
            node.flexView = flexView
            
            return node
        }
    }
    
    // MARK: Private Methods
    
    /// Setup the node with config
    fileprivate func install() {
        YGNodeSetContext(yogaNode, Unmanaged<FlexView>.passUnretained(flexView).toOpaque())
        flexConfig.configYogaNode(yogaNode)
    }
    
    /// Insert child flex node recursively
    ///
    /// - Parameter childNode: flex node
    private func insert(childNode: FlexNode) {
        if childNode.children.count == 0 {
            while YGNodeGetChildCount(childNode.yogaNode) > 0 {
                YGNodeRemoveChild(childNode.yogaNode, YGNodeGetChild(childNode.yogaNode, YGNodeGetChildCount(childNode.yogaNode) - 1));
            }
            
            YGNodeSetMeasureFunc(childNode.yogaNode) { (node, width, widthMode, height, heightMode) -> YGSize in
                var nodeWidth = width;
                var nodeHeight = height;
                if widthMode == YGMeasureMode.undefined {
                    nodeWidth = Float(CGFloat.greatestFiniteMagnitude)
                }
                if heightMode == YGMeasureMode.undefined {
                    nodeHeight = Float(CGFloat.greatestFiniteMagnitude)
                }
                // https://www.jianshu.com/p/23b44cd76ce6
                let view = Unmanaged<FlexView>.fromOpaque(YGNodeGetContext(node)).takeUnretainedValue()
                
                var sizeThatFits = CGSize.zero
                if let flexBox = view as? FlexBoxSizeAdaptive {
                    sizeThatFits = flexBox.sizeThatFits(CGSize(width: Double(nodeWidth), height: Double(nodeHeight)))
                    // size 向上取整
                    sizeThatFits = CGSize(width: ceil(sizeThatFits.width), height: ceil(sizeThatFits.height))
                }
                
                var size = CGSize.zero
                
                switch widthMode {
                case .exactly:
                    size.width = CGFloat(nodeWidth)
                    break
                case .atMost:
                    size.width = min(CGFloat(nodeWidth), sizeThatFits.width)
                    break
                case .undefined:
                    size.width = sizeThatFits.width
                    break
                default:
                    break
                }
                
                switch heightMode {
                case .exactly:
                    size.height = CGFloat(nodeHeight)
                    break
                case .atMost:
                    size.height = min(CGFloat(nodeHeight), sizeThatFits.height)
                    break
                case .undefined:
                    size.height = sizeThatFits.height
                    break
                default:
                    break
                }
                
                return YGSize(width: Float(size.width), height: Float(size.height))
            }
        } else {
            YGNodeSetMeasureFunc(childNode.yogaNode, nil);
            
            while YGNodeGetChildCount(childNode.yogaNode) > 0 {
                YGNodeRemoveChild(childNode.yogaNode, YGNodeGetChild(childNode.yogaNode, YGNodeGetChildCount(childNode.yogaNode) - 1));
            }
            for index in 0...childNode.children.count-1 {
                let child = childNode.children[index]
                YGNodeInsertChild(childNode.yogaNode, child.yogaNode, UInt32(index));
            }
            for child in childNode.children {
                insert(childNode: child)
            }
        }
    }
    
    /// Calculate frame from flexView instance recursively
    ///
    /// - Parameter childNode: flex node
    private func layout(childNode: FlexNode) {
        let top = YGNodeLayoutGetTop(childNode.yogaNode)
        let left = YGNodeLayoutGetLeft(childNode.yogaNode)
        let width = YGNodeLayoutGetWidth(childNode.yogaNode)
        let height = YGNodeLayoutGetHeight(childNode.yogaNode)
        
        if childNode.flexView.frame.origin == CGPoint.zero {
            childNode.flexView.frame = CGRect(x: CGFloat(left), y: CGFloat(top), width: CGFloat(width), height: CGFloat(height))
        } else {
            childNode.flexView.frame = CGRect(x: childNode.flexView.frame.origin.x, y: childNode.flexView.frame.origin.y, width: CGFloat(width), height: CGFloat(height))
        }
        for child in childNode.children {
            layout(childNode: child)
        }
    }
    
    /// Render view from flexView instance recursively
    ///
    /// - Parameters:
    ///   - childNode: flex node
    ///   - rootView: UIView of root flex node
    ///   - parentView: UIView of parent flex node
    private func render(childNode: FlexNode, rootView: UIView, parentView: UIView?) {
        var p: UIView
        if let parent = parentView {
            p = parent
            let view = childNode.flexView.view(from: childNode)
            p.addSubview(view)
            p = view
        } else {
            p = rootView
        }
        for node in childNode.children {
            render(childNode: node, rootView: rootView, parentView: p)
        }
    }
    
    private mutating func calculateRootNodeSize() {
        assert(isRoot, "This function can be used only on root flexNode")
        guard nodeSize == .zero else { return }
        insert(childNode: self)
        if flexView.frame.size == CGSize.zero {
            YGNodeCalculateLayout(yogaNode, YGValueUndefined.value, YGValueUndefined.value, YGNodeStyleGetDirection(yogaNode));
        } else {
            YGNodeCalculateLayout(yogaNode, Float(flexView.frame.size.width), Float(flexView.frame.size.height), YGNodeStyleGetDirection(yogaNode));
        }
        layout(childNode: self)
        
        let width = YGNodeLayoutGetWidth(yogaNode)
        let height = YGNodeLayoutGetHeight(yogaNode)
        
        nodeSize = CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
}
