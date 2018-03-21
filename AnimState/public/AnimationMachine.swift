//
//  AnimationMachine.swift
//  AnimationMachine
//
//  Created by Downey, Eric on 3/8/18.
//  Copyright © 2018 Downey. All rights reserved.
//

/// Animation Machine is used to create different animation states of a UIView. Each state requires a transition that is responsible for animating to the corresponding state.
public struct AnimationMachine<StateType: ViewState> {
    
    // MARK: - Enums
    
    /// VMError is an enum of throwable values.
    ///
    /// - unknownState: Thrown when the state node cannot be retrieved from the given state.
    /// - unsetTransition: Thrown when the transition cannot be retrieved from the given state.
    public enum VMError: Error {
        case unknownState(StateType)
        case unsetTransition(StateType)
    }
    
    // MARK: - Typealiases
    
    /// The closure type for a transition between states.
    public typealias Transition = () -> Void
    /// The closure type for the completion of a transition.
    public typealias AnimationCompletion = (Bool) -> Void
    
    // MARK: - Properties
    
    let animationConfig: AnimationConfig
    var stateBag: AnimationStateBag<StateType>
    
    // MARK: - Constructor
    
    /// Initializes an Animation Machine
    ///
    /// - Parameters:
    ///   - animationConfig: The configuration for this machine. The configuration can be a basic animation or spring animation.
    ///   - state: The staring state for the animation machine
    ///   - transition: The transition for the root node transition
    public init(animationConfig: AnimationConfig, startingAt state: StateType, withTransition transition: @escaping AnimationMachine.Transition) {
        self.stateBag = AnimationStateBag(root: (state, AnimationNode(transition: transition, chainItem: nil)), states: [:])
        self.animationConfig = animationConfig
    }
}
