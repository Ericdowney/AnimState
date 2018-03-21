//
//  AnimationStateBag.swift
//  AnimState
//
//  Created by Downey, Eric on 3/21/18.
//  Copyright © 2018 Downey. All rights reserved.
//

struct AnimationStateBag<StateType: ViewState> {
    var root: (state: StateType, node: AnimationNode)
    var states: [StateType: AnimationItem] = [:]
    
    mutating func addState(_ state: StateType, node: AnimationItem) {
        states[state] = node
    }
    
    func animationItem(from state: StateType) -> AnimationItem? {
        if root.state == state {
            return root.node
        }
        return states[state]
    }
}
