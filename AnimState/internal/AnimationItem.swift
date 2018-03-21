//
//  AnimationItem.swift
//  AnimState
//
//  Created by Downey, Eric on 3/21/18.
//  Copyright © 2018 Downey. All rights reserved.
//

protocol AnimationItem {
    typealias Transition = () -> Void
    
    var transition: Transition { get }
    var chainItem: AnimationItem? { get set }
    
    mutating func addRecursively(chainItem: AnimationItem)
}
