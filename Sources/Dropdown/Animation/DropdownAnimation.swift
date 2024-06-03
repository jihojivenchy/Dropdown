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

public struct AnimationConfiguration {
    let duration: TimeInterval
    let damping: CGFloat
    let velocity: CGFloat
}
