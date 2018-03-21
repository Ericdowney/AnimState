//
//  AnimationMachine+Transitions.swift
//  AnimState
//
//  Created by Downey, Eric on 3/21/18.
//  Copyright © 2018 Downey. All rights reserved.
//

extension AnimationMachine {
    /// Resets the Animation Machine to the root state
    ///
    /// - Returns: Animation Machine
    @discardableResult
    public func reset() -> AnimationMachine {
        return try! transition(to: stateBag.root.state)
    }
    
    /// Transitions to the given state, optionally with an animation config and a completion block.
    ///
    /// - Parameters:
    ///   - state: The state to transition to.
    ///   - config: An animation config that will be used instead of the machine level config.
    ///   - complete: The completion block to be called when the animation finishes.
    /// - Returns: Animation Machine
    /// - Throws: VMError
    @discardableResult
    public func transition(to state: StateType, with config: AnimationConfig? = nil, whenComplete complete: AnimationCompletion? = nil) throws -> AnimationMachine {
        guard let node = stateBag.animationItem(from: state) else {
            throw VMError.unknownState(state)
        }
        return transition(to: node,
                          with: config,
                          whenComplete: complete)
    }
    
    private func transition(to node: AnimationItem, with config: AnimationConfig? = nil, whenComplete complete: AnimationCompletion? = nil) -> AnimationMachine {
        if case .none = config ?? animationConfig {
            var animNode: AnimationItem? = node
            animNode?.transition()
            while let item = animNode?.chainItem {
                item.transition()
                animNode = animNode?.chainItem
            }
        }
        if case .simple(let config) = config ?? animationConfig {
            animateSimpleConfig(config, node: node, complete: complete)
        }
        if case .spring(let config) = config ?? animationConfig {
            animateSpringConfig(config, node: node, complete: complete)
        }
        return self
    }
    
    private func animateSimpleConfig(_ config: (duration: TimeInterval, delay: TimeInterval, options: UIViewAnimationOptions), node: AnimationItem, complete: AnimationCompletion? = nil) {
        var animNode: AnimationItem? = node
        var stack: [AnimationItem] = [node]
        while let item = animNode?.chainItem {
            stack.append(item)
            animNode = animNode?.chainItem
        }
        for (index, item) in stack.enumerated() {
            UIView.animate(withDuration: config.duration,
                           delay: (config.duration * Double(index) ) + config.delay,
                           options: config.options,
                           animations: item.transition,
                           completion: index == stack.count - 1 ? complete : nil)
        }
    }
    
    private func animateSpringConfig(_ config: (duration: TimeInterval, delay: TimeInterval, springDamping: CGFloat, initialVelocity: CGFloat, options: UIViewAnimationOptions), node: AnimationItem, complete: AnimationCompletion? = nil) {
        var animNode: AnimationItem? = node
        var stack: [AnimationItem] = [node]
        while let item = animNode?.chainItem {
            stack.append(item)
            animNode = animNode?.chainItem
        }
        // TODO: This is not the healthiest way to achieve chained animations.  Re-evaluate and make this better.
        for (index, item) in stack.enumerated() {
            UIView.animate(withDuration: config.duration,
                           delay: (config.duration * Double(index) ) + config.delay,
                           usingSpringWithDamping: config.springDamping,
                           initialSpringVelocity: config.initialVelocity,
                           options: config.options,
                           animations: item.transition,
                           completion: index == stack.count - 1 ? complete : nil)
        }
    }
}
