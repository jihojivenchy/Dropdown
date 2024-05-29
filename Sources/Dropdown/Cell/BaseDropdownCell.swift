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
    
    var selectedTextColor: UIColor?
    var nomalTextColor: UIColor?
    var selectedBackgroundColor: UIColor?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayouts()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    open func configureLayouts() {
        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(optionLabel)
        
        optionLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        optionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        optionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        optionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
    }
    
    // MARK: - Methods
    open override var isSelected: Bool {
        willSet {
            setSelected(newValue, animated: false)
        }
    }
    
    open override func setSelected(_ selected: Bool, animated: Bool) {
        backgroundColor = selected ? selectedBackgroundColor : .clear
        optionLabel.textColor = selected ? selectedTextColor : nomalTextColor
    }
}
