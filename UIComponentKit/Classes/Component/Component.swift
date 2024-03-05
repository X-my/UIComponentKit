//
//  Component.swift
//
//  Created by 许梦阳 on 2023/3/30.
//

import Foundation

public struct State {
    public var value: Any?
    public var attributes: Dictionary<String, Any>?
    
    /// TEST
    /// Init the state with a value
    ///
    /// - Parameter value: value of this state
    public init(_ value: Any?) {
        self.value = value
    }
    
    /// Init the state with a value and an attribute
    ///
    /// - Parameters:
    ///   - value: value of this state
    ///   - attributes: attribute of this state
    public init(value: Any?, attributes: Dictionary<String, Any>) {
        self.value = value
        self.attributes = attributes
    }
}

public protocol Statefull: Component {
    
    associatedtype View: UIView
    
    /// Component did update
    func componentDidUpdate(view: View?)
    
    func updateState(closure: (State) -> State)
    
    func view() -> View?
}

public extension Statefull {
    
    /// Update the state of the component
    ///
    /// - Parameter closure: closure that build the new state
    func updateState(closure: (State) -> State) {
        state = closure(state)
        
        componentDidUpdate(view: view())
        
        parent?.childComponentDidUpdate(child: self)
    }
    
    func view() -> UIView? {
        return nil
    }
}

public protocol Sizeable {
    /// Return the UI size of the component
    ///
    /// - Parameter state: state of this component
    /// - Returns: size of this component
    func componentSize(from state: State) -> CGSize
}

open class Component: NSObject {
    /// Parent of the component
    public weak var parent: Component?
    /// Children of the component
    public var children: Array<Component>
    /// State of the component
    public var state: State
    
    // MARK: Open API Methods
    
    /// Init component with a state
    ///
    /// - Parameter state: state of this component
    public init(_ state: State) {
        self.parent = nil
        self.children = []
        self.state = state
    }
    
    /// Add child component
    ///
    /// - Parameter childComponent: child component
    public func add(childComponent: Component) {
        childComponent.parent = self
        children.append(childComponent)
    }
    
    /// Clear all the child components
    public func clear() {
        children = []
    }
    
    public func childComponentDidUpdate(child: Component) {
        
    }
    
}
