//
//  AnimationStateBagTests.swift
//  AnimStateTests
//
//  Created by Downey, Eric on 3/21/18.
//  Copyright © 2018 Downey. All rights reserved.
//

import XCTest
@testable import AnimState

class AnimationStateBagTests: XCTestCase {
    
    var isRootStateNodeCompleted: Bool = false
    var subject: AnimationStateBag<TestState>!
    
    override func setUp() {
        super.setUp()
        
        subject = AnimationStateBag(root: (.one, node: AnimationNode(transition: {
            self.isRootStateNodeCompleted = true
        }, chainItem: nil)), states: [:])
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_shouldAddNodeToStates() {
        let newState: TestState = .two
        var completed = false
        let newNode = AnimationNode(transition: {
            completed = true
        }, chainItem: nil)
        
        subject.addState(newState, node: newNode)
        
        XCTAssertTrue(subject.states.contains(where: { $0.key == .two }))
        
        let node = subject.states[.two]
        node?.transition()
        
        XCTAssertTrue(completed)
    }
    
    func test_shouldReturnTheRootStateNode() {
        let result = subject.animationItem(from: .one)
        
        result?.transition()
        
        XCTAssertTrue(isRootStateNodeCompleted)
    }
    
    func test_shouldReturnANodeFromState() {
        let newState: TestState = .two
        var completed = false
        let newNode = AnimationNode(transition: {
            completed = true
        }, chainItem: nil)
        subject.addState(newState, node: newNode)
        
        let result = subject.animationItem(from: .two)
        
        result?.transition()
        
        XCTAssertTrue(completed)
    }
}
