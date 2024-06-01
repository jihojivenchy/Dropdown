//
//  DropdownDelegate.swift
//  Dropdown
//
//  Created by 엄지호 on 6/1/24.
//

import Foundation

public protocol DropdownDelegate: AnyObject {
    func willShow()
    func willHide()
    func itemSelected(itemTitle: String, itemIndexRow: IndexRow)
}

extension DropdownDelegate {
    func willShow() { }
    func willHide() { }
    func itemSelected(itemTitle: String, itemIndexRow: IndexRow) { }
}
