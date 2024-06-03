//
//  DropdownAnimation.swift
//
//
//  Created by 엄지호 on 6/2/24.
//

import UIKit

public struct DropdownAnimation {
    let type: DropdownAnimationType
    let configuration: AnimationConfiguration
    
    /// Initializes a new dropdown animation.
    ///
    /// - Parameters:
    ///   - type: The type of animation. Defaults to `.slide`.
    ///   - configuration: The configuration for the animation. If not provided, default values are used based on the animation type.
    public init(type: DropdownAnimationType = .slide, configuration: AnimationConfiguration? = nil) {
        self.type = type
        self.configuration = configuration ?? {
            switch type {
            case .slide: return AnimationConfiguration(duration: 0.5, damping: 0.8, velocity: 0.5)
            case .scale: return AnimationConfiguration(duration: 0.3, damping: 0.6, velocity: 0.1)
            }
        }()
    }
}

public enum DropdownAnimationType {
    case slide
    case scale
}

/// A configuration for animation properties.
public struct AnimationConfiguration {
    let duration: TimeInterval
    let damping: CGFloat
    let velocity: CGFloat
    
    /// The transform applied when the animation type is `.scale`.
    /// This determines how much the view scales down before returning to its original size.
    /// The default value is `CGAffineTransform(scaleX: 0.6, y: 0.6)`, meaning the view scales down to 60% of its original size.
    let downScaleTransform: CGAffineTransform
    
    
    /// Initializes a new animation configuration.
    ///
    /// - Parameters:
    ///   - duration: The duration of the animation.
    ///   - damping: The damping ratio for the animation.
    ///   - velocity: The initial velocity of the animation.
    ///   - downScaleTransform: The transform applied when the animation type is `.scale`.
    ///     Default is `CGAffineTransform(scaleX: 0.6, y: 0.6)`.
    public init(
        duration: TimeInterval,
        damping: CGFloat,
        velocity: CGFloat,
        downScaleTransform: CGAffineTransform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    ) {
        self.duration = duration
        self.damping = damping
        self.velocity = velocity
        self.downScaleTransform = downScaleTransform
    }
}
