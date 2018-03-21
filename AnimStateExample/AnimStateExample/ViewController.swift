//
//  ViewController.swift
//  AnimStateExample
//
//  Created by Downey, Eric on 3/8/18.
//  Copyright © 2018 Downey. All rights reserved.
//

import UIKit
import AnimState

class Box: UIView {
    convenience init(color: UIColor?, frame: CGRect) {
        self.init(frame: frame)
        self.backgroundColor = color
    }
}

enum TestState: ViewState {
    case red, yellow, green, blue, purple, chainedReset
    
    var next: TestState {
        switch self {
        case .red:
            return .yellow
        case .yellow:
            return .green
        case .green:
            return .blue
        case .blue:
            return .purple
        case .purple:
            return .red
        default:
            return .red
        }
    }
}

class ViewController: UIViewController {
    
    var viewState: TestState = .red {
        didSet {
            _ = try? machine.transition(to: viewState)
        }
    }
    
    lazy var boxes: [Box] = {
        [
            Box(color: .red, frame: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 50)),
            Box(color: .yellow, frame: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 50)),
            Box(color: .green, frame: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 50)),
            Box(color: .blue, frame: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 50)),
            Box(color: .purple, frame: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 50)),
        ]
    }()
    lazy var machine: AnimationMachine<TestState> = {
//        .none
//        .simple(duration: 0.4, delay: 0.0, options: .curveEaseInOut)
//        .spring(duration: 0.4, delay: 0.0, springDamping: 0.75, initialVelocity: 0.1, options: .curveEaseInOut)
        AnimationMachine<TestState>(animationConfig: .spring(duration: 0.4, delay: 0.0, springDamping: 0.75, initialVelocity: 0.1, options: .curveEaseInOut), startingAt: viewState, withTransition: setFramesTo(n: 0))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boxes.forEach(view.addSubview)
        
        machine.reset()
        machine.addState(.yellow, with: setFramesTo(n: 1))
        machine.addState(.green, with: setFramesTo(n: 2))
        machine.addState(.blue, with: setFramesTo(n: 3))
        machine.addState(.purple, with: setFramesTo(n: 4))
        machine.addState(.chainedReset, with: setFramesTo(n: 4))
        
        do {
            try machine.addChain(to: .chainedReset, with: setFramesTo(n: 3))
            try machine.addChain(to: .chainedReset, with: setFramesTo(n: 2))
            try machine.addChain(to: .chainedReset, with: setFramesTo(n: 1))
            try machine.addChain(to: .chainedReset, with: setFramesTo(n: 0))
        }
        catch {}
    }
    
    // MARK: - Methods
    
    func setFramesTo(n: Int) -> AnimationMachine<TestState>.Transition {
        return { [unowned self] in
            let box = self.boxes[n]
            for (index, item) in self.boxes.enumerated() {
                if index < n {
                    item.frame = CGRect(x: 10, y: 50 + CGFloat(75 * index), width: view.frame.width - 20, height: 50.0)
                }
                if index > n {
                    item.frame = CGRect(x: 10, y: view.frame.height + CGFloat(75 * index), width: view.frame.width - 20, height: 50.0)
                }
            }
            box.frame = CGRect(x: 10, y: view.frame.height - 200, width: view.frame.width - 20, height: 100.0)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func nextState() {
        viewState = viewState.next
    }
    
    @IBAction func red() {
        viewState = .red
    }
    
    @IBAction func yellow() {
        viewState = .yellow
    }
    
    @IBAction func green() {
        viewState = .green
    }
    
    @IBAction func blue() {
        viewState = .blue
    }
    
    @IBAction func purple() {
        viewState = .purple
    }
    
    @IBAction func reset() {
        viewState = .chainedReset
    }
    
}

