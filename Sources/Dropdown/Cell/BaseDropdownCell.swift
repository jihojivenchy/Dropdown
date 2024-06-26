//
//  BaseDropdownCell.swift
//  Dropdown
//
//  Created by 엄지호 on 5/10/24.
//

import UIKit

open class BaseDropdownCell: UITableViewCell {
    // MARK: - UI
    static let identifier = "DropdownCell"
    
    public let optionLabel = UILabel()
    
    // MARK: - Properties
    open override var isSelected: Bool {
        willSet {
            setSelected(newValue, animated: false)
        }
    }
    
    var selectedTextColor: UIColor?
    var normalTextColor: UIColor?
    var selectedBackgroundColor: UIColor?
    
    // MARK: - Layouts
    func configureLayouts() {
        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(optionLabel)
        
        optionLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        optionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        optionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        optionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
    }
    
    // MARK: - Methods
    open override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = selected ? selectedBackgroundColor : .clear
        optionLabel.textColor = selected ? selectedTextColor : normalTextColor
    }
}
