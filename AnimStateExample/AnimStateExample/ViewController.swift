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
    case red, yellow, green, blue, purple
    
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
        }
    }
}

class ViewController: UIViewController {
    
    var currentState: TestState = .red
    
    var boxes: [Box] = []
    lazy var machine: ViewMachine<TestState> = {
        return ViewMachine<TestState>(animationConfig: .spring(duration: 0.4, delay: 0.0, springDamping: 0.75, initialVelocity: 0.1, options: .curveEaseInOut), startingAt: currentState, withTransition: setFramesTo(n: 0))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        boxes = [
            Box(color: .red, frame: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 50)),
            Box(color: .yellow, frame: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 50)),
            Box(color: .green, frame: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 50)),
            Box(color: .blue, frame: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 50)),
            Box(color: .purple, frame: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 50)),
        ]
        boxes.forEach(view.addSubview)
        
        do {
            try machine.reset()
            try machine.set(next: .yellow, from: .red, with: setFramesTo(n: 1))
            try machine.set(next: .green, from: .yellow, with: setFramesTo(n: 2))
            try machine.set(next: .blue, from: .green, with: setFramesTo(n: 3))
            try machine.set(next: .purple, from: .blue, with: setFramesTo(n: 4))
        }
        catch {
            let alert = UIAlertController(title: "Machine Error", message: "Could not setup machine states", preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: nil) )
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Methods
    
    func setFramesTo(n: Int) -> ViewMachine<TestState>.Transition {
        return {
            let box = self.boxes[n]
            for (index, item) in self.boxes.enumerated() {
                if index < n {
                    item.frame = CGRect(x: 10, y: 50 + CGFloat(75 * index), width: self.view.frame.width - 20, height: 50.0)
                }
                if index > n {
                    item.frame = CGRect(x: 10, y: self.view.frame.height + CGFloat(75 * index), width: self.view.frame.width - 20, height: 50.0)
                }
            }
            box.frame = CGRect(x: 10, y: self.view.frame.height - 200, width: self.view.frame.width - 20, height: 100.0)
        }
    }
    
    // MARK: - Actions

    @IBAction func nextState() {
        do {
            try machine.transition(to: currentState.next)
            currentState = currentState.next
        }
        catch {}
    }
    
    @IBAction func red() {
        goTo(state: .red)
    }
    
    @IBAction func yellow() {
        goTo(state: .yellow)
    }
    
    @IBAction func green() {
        goTo(state: .green)
    }
    
    @IBAction func blue() {
        goTo(state: .blue)
    }
    
    @IBAction func purple() {
        goTo(state: .purple)
    }
    
    private func goTo(state: TestState) {
        do {
            try machine.transition(to: state)
            currentState = state
        }
        catch {}
    }
    
}

