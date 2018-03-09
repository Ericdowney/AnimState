//
//  AnimState.swift
//  AnimState
//
//  Created by Downey, Eric on 3/8/18.
//  Copyright © 2018 Downey. All rights reserved.
//

import Foundation

// MARK: - Configuration

public protocol ViewState: Hashable {}

public enum AnimationConfig {
    case simple(duration: TimeInterval, delay: TimeInterval, options: UIViewAnimationOptions)
    case spring(duration: TimeInterval, delay: TimeInterval, springDamping: CGFloat, initialVelocity: CGFloat, options: UIViewAnimationOptions)
}

public struct AnimationNode<StateType: ViewState>: Hashable {
    public var state: StateType
    public var transition: ViewMachine<StateType>.Transition
}

public extension AnimationNode {
    public var hashValue: Int {
        return state.hashValue
    }
    
    public static func ==(lhs: AnimationNode, rhs: AnimationNode) -> Bool {
        return lhs.state == rhs.state
    }
}

// MARK: - State Machine

public struct ViewMachine<StateType: ViewState> {
    
    // MARK: - Enums
    
    public enum VMError: Error {
        case unknownState(StateType)
        case unsetTransition(StateType)
    }
    
    // MARK: - Typealiases
    
    public typealias Transition = () -> Void
    public typealias AnimationCompletion = (Bool) -> Void
    
    // MARK: - Constants
    
    let animationConfig: AnimationConfig
    
    // MARK: - Properties
    
    var states: Graph<AnimationNode<StateType>>
    var rootState: Node<AnimationNode<StateType>>
    
    // MARK: - Constructor
    
    public init(animationConfig: AnimationConfig, startingAt state: StateType, withTransition transition: @escaping ViewMachine.Transition) {
        self.states = Graph()
        self.animationConfig = animationConfig
        self.rootState = states.createNode(with: AnimationNode(state: state, transition: transition))
    }
    
    // MARK: - Methods
    
    public mutating func set(root state: StateType, with transition: @escaping ViewMachine.Transition) -> ViewMachine {
        rootState = states.createNode(with: AnimationNode(state: state, transition: transition))
        return self
    }
    
    @discardableResult
    public mutating func set(next state: StateType, from otherState: StateType, with transition: @escaping ViewMachine.Transition) throws -> ViewMachine {
        guard let oldNode = states.node(where: { $0.data.state == otherState }) else {
            throw VMError.unknownState(otherState)
        }
        let newNode = states.createNode(with: AnimationNode(state: state, transition: transition))
        states.addEdge(from: oldNode, to: newNode)
        return self
    }
    
//    @discardableResult
//    public func next() throws -> ViewMachine {
//        return self
//    }
    
    @discardableResult
    public func reset() throws -> ViewMachine {
        return try transition(to: rootState.data.state)
    }
    
    @discardableResult
    public func transition(to state: StateType, with config: AnimationConfig? = nil, whenComplete complete: AnimationCompletion? = nil) throws -> ViewMachine {
        guard let node = states.node(where: { $0.data.state == state }) else {
            throw VMError.unknownState(state)
        }
        return try transition(to: node.data,
                              with: config,
                              whenComplete: complete)
    }
    
    private func transition(to node: AnimationNode<StateType>, with config: AnimationConfig? = nil, whenComplete complete: AnimationCompletion? = nil) throws -> ViewMachine {
        if case .simple(let config) = config ?? animationConfig {
            UIView.animate(withDuration: config.duration,
                           delay: config.delay,
                           options: config.options,
                           animations: node.transition,
                           completion: complete)
        }
        if case .spring(let config) = config ?? animationConfig {
            UIView.animate(withDuration: config.duration,
                           delay: config.delay,
                           usingSpringWithDamping: config.springDamping,
                           initialSpringVelocity: config.initialVelocity,
                           options: config.options,
                           animations: node.transition,
                           completion: complete)
        }
        return self
    }
}
