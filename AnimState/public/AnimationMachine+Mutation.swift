//
//  AnimationMachine+Mutation.swift
//  AnimState
//
//  Created by Downey, Eric on 3/21/18.
//  Copyright © 2018 Downey. All rights reserved.
//

extension AnimationMachine {
    /// Re-Sets the root node of the Animation Machine to the given state and transition.
    ///
    /// - Parameters:
    ///   - state: The root state type.
    ///   - transition: The transition for the root state
    /// - Returns: Animation Machine
    @discardableResult
    public mutating func set(root state: StateType, with transition: @escaping AnimationMachine.Transition) -> AnimationMachine {
        stateBag.root = (state, AnimationNode(transition: transition, chainItem: nil))
        return self
    }
    
    /// Creates a new node in the Animation Machine between the two provided states.
    ///
    /// - Parameters:
    ///   - state: The next state in the machine
    ///   - otherState: The previous state in the machine to be transitioned from.
    ///   - transition: The transition to be used when transitioning from otherState to state.
    /// - Returns: Animation Machine
    /// - Throws: VMError
    @discardableResult
    public mutating func addState(_ state: StateType, with transition: @escaping AnimationMachine.Transition) -> AnimationMachine {
        stateBag.addState(state, node: AnimationNode(transition: transition, chainItem: nil))
        return self
    }
    
    @discardableResult
    public mutating func addChain(to state: StateType, with transition: @escaping AnimationMachine.Transition) throws -> AnimationMachine {
        guard var node = stateBag.animationItem(from: state) else {
            throw VMError.unknownState(state)
        }
        let newNode = AnimationNode(transition: transition, chainItem: nil)
        node.addRecursively(chainItem: newNode)
        stateBag.addState(state, node: node)
        return self
    }
}
