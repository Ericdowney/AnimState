//
//  AnimationNodeTests.swift
//  AnimStateTests
//
//  Created by Downey, Eric on 3/21/18.
//  Copyright © 2018 Downey. All rights reserved.
//

import XCTest
@testable import AnimState

class AnimationNodeTests: XCTestCase {
    
    var subject: AnimationNode!
    
    override func setUp() {
        super.setUp()
        
        subject = AnimationNode(transition: {}, chainItem: nil)
    }
    
    func test_shouldAddTheChainedItemToTheNode() {
        var completed = false
        let newItem = AnimationNode(transition: {
            completed = true
        }, chainItem: nil)
        
        subject.addRecursively(chainItem: newItem)
        
        subject.chainItem?.transition()
        
        XCTAssertTrue(completed)
    }
    
    func test_shouldAddANewChainItemToAnAlreadyChainedSubItem() {
        var completed = false
        let finalItem = AnimationNode(transition: {
            completed = true
        }, chainItem: nil)
        
        subject.addRecursively(chainItem: AnimationNode(transition: {}, chainItem: nil))
        subject.addRecursively(chainItem: AnimationNode(transition: {}, chainItem: nil))
        subject.addRecursively(chainItem: finalItem)
        
        subject.chainItem?.chainItem?.chainItem?.transition()
        
        XCTAssertTrue(completed)
    }
}
