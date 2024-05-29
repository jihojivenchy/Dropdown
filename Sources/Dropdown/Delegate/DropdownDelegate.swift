//
//  DropdownDelegate.swift
//  Dropdown
//
//  Created by 엄지호 on 5/10/24.
//

import Foundation

public protocol DropdownDelegate: AnyObject {
    func willShow()
    func willHide()
    func itemSelected(title: String, indexRow: Int)
}

extension DropdownDelegate {
    func willShow() { }
    func willHide() { }
    func itemSelected(title: String, indexRow: Int) { }
}
