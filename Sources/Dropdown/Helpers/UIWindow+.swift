//
//  UIWindow+.swift
//  Dropdown
//
//  Created by 엄지호 on 5/10/24.
//

import UIKit

// MARK: - Window
extension UIWindow {
    static func visibleWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first(where: { $0.isKeyWindow })
    }
}

extension UIView {
    var windowFrame: CGRect? {
        return superview?.convert(frame, to: nil)
    }
}
