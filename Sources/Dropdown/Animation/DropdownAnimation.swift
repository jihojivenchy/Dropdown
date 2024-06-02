//
//  DropdownAnimation.swift
//
//
//  Created by 엄지호 on 6/2/24.
//

import UIKit

public enum DropdownAnimation {
    case slideDown(configuration: AnimationConfiguration?)
    case scale(configuration: AnimationConfiguration?)
}

public struct AnimationConfiguration {
    let duration: TimeInterval
    let damping: CGFloat
    let velocity: CGFloat
}
