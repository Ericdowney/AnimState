//
//  AnimationNode.swift
//  AnimState
//
//  Created by Downey, Eric on 3/21/18.
//  Copyright © 2018 Downey. All rights reserved.
//

struct AnimationNode: AnimationItem {
    var transition: AnimationItem.Transition
    var chainItem: AnimationItem?
    
    mutating func addRecursively(chainItem: AnimationItem) {
        if self.chainItem == nil {
            self.chainItem = chainItem
        }
        else {
            self.chainItem?.addRecursively(chainItem: chainItem)
        }
    }
}
