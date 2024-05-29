//
//  AnchorView.swift
//  Dropdown
//
//  Created by 엄지호 on 5/10/24.
//

import UIKit

public protocol AnchorView: AnyObject {
    var plainView: UIView { get }
}

extension UIView: AnchorView {
    public var plainView: UIView {
        return self
    }
}

extension UIBarButtonItem: AnchorView {
    public var plainView: UIView {
        return value(forKey: "view") as? UIView ?? UIView()
    }
}
