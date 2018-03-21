//
//  AnimationConfig.swift
//  AnimState
//
//  Created by Downey, Eric on 3/21/18.
//  Copyright © 2018 Downey. All rights reserved.
//

/// The configuration to be used by an Animation Machine to animate states.
///
/// - simple: This configuration is for basic animations.
/// - spring: This configuration is for spring based animations.
public enum AnimationConfig {
    case none
    case simple(duration: TimeInterval, delay: TimeInterval, options: UIViewAnimationOptions)
    case spring(duration: TimeInterval, delay: TimeInterval, springDamping: CGFloat, initialVelocity: CGFloat, options: UIViewAnimationOptions)
}
