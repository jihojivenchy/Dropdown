//
//  DropdownDelegate.swift
//  Dropdown
//
//  Created by 엄지호 on 6/1/24.
//

import Foundation

public protocol DropdownDelegate: AnyObject {
    /// The action to execute when the drop down will show.
    func willShow()
    
    /// The action to execute when the hides the drop down.
    func willHide()
    
    /// A closure that gets called when an item is selected in a list.
    /// The closure takes two parameters: the selected element and the row of the selected cell
    func itemSelected(itemTitle: String, itemIndexRow: IndexRow)
}

public extension DropdownDelegate {
    func willShow() { }
    func willHide() { }
    func itemSelected(itemTitle: String, itemIndexRow: IndexRow) { }
}
