//
//  Dropdown.swift
//  Dropdown
//
//  Created by 엄지호 on 5/10/24.
//

import UIKit

public typealias IndexRow = Int
public typealias Closure = () -> Void
public typealias ItemSelectedClosure = (String, IndexRow) -> Void
public typealias CellConfigurationClosure = (IndexRow, String, UITableViewCell) -> Void

public class Dropdown: UIView {
    // MARK: - DropdownGeometry
    private struct DropdownGeometry {
        var x: CGFloat
        var y: CGFloat
        var width: CGFloat
        var height: CGFloat
        var overflowHeight: CGFloat
        var visibleHeight: CGFloat
        var isVisible: Bool
    }
    
    private var dropdownGeometry = DropdownGeometry(
        x: 0,
        y: 0,
        width: 0,
        height: 0,
        overflowHeight: 0,
        visibleHeight: 0,
        isVisible: false
    )
    
    // MARK: - UI
    private let backgroundView = UIView()
    private let dropdownContainer = UIView()
    private let dropdownTableView = UITableView()
    
    private weak var anchorView: AnchorView?
    
    // MARK: - Cell Style
    private var cellHeight: CGFloat
    private var itemTextColor: UIColor?
    private var itemTextFont: UIFont
    private var selectedItemTextColor: UIColor?
    private var selectedItemBackgroundColor: UIColor?
    private var separatorColor: UIColor?
    private var tableViewBackgroundColor: UIColor?
    
    // MARK: - UI Properties
    private var width: CGFloat?
    private var cornerRadius: CGFloat
    private var borderWidth: CGFloat
    private var borderColor: CGColor
    private var shadowColor: UIColor
    private var shadowOffset: CGSize
    private var shadowOpacity: Float
    private var shadowRadius: CGFloat
    
    private var dimmedBackgroundColor: UIColor?
    
    private var tableHeight: CGFloat {
        return dropdownTableView.rowHeight * CGFloat(dataSource.count)
    }
    
    // MARK: - Dropdown Layout Properties
    private var bottomOffset: CGPoint
    
    private var dropdownTopConstraint: NSLayoutConstraint?
    private var dropdownHeightConstraint: NSLayoutConstraint?
    private var dropdownLeadingConstraint: NSLayoutConstraint?
    private var dropdownWidthConstraint: NSLayoutConstraint?
    
    // MARK: - Animation
    private var animationduration: Double
    private var downScaleTransform: CGAffineTransform
    
    
    // MARK: - Custom Cell
    private var customCellType: UITableViewCell.Type
    private var customCellConfiguration: CellConfigurationClosure?
    
    // MARK: - Action
    /// The action to execute when the drop down will show.
    public var willShow: Closure?

    /// The action to execute when the hides the drop down.
    public var willHide: Closure?
    
    /// A closure that gets called when an item is selected in a list.
    /// The closure takes two parameters: the selected element and the row of the selected cell
    public var itemSelected: ItemSelectedClosure?
    
    // MARK: - Property
    public var dataSource: [String] {
        didSet {
            updateDropdownLayout()
        }
    }
    
    public var selectedItemIndexRow: IndexRow? {
        didSet {
            dropdownTableView.reloadData()
        }
    }
    
    // MARK: - Init
    /// Initializes the dropdown menu, requiring an anchor view and a data source as basic inputs.
    /// - Parameters:
    ///   - anchorView: The view that acts as a reference for positioning and triggering the dropdown.
    ///   - bottomOffset: The vertical space between the dropdown and the anchorView.
    ///   - dataSource: The source of data for dropdown items.
    ///   - cellHeight: The height of each dropdown item.
    ///   - itemTextColor: The text color for dropdown items.
    ///   - itemTextFont: The font of the text for dropdown items.
    ///   - selectedItemTextColor: The text color for a selected dropdown item.
    ///   - selectedItemBackgroundColor: The background color for a selected dropdown item.
    ///   - separatorColor: The color of separators between dropdown items.
    ///   - dimmedBackgroundColor: The background color of the overlay when the dropdown is active.
    ///   - width: The width of the dropdown; defaults to anchorView.bounds.width minus bottomOffset.x.
    ///   - animationDuration: The duration of the animation for showing and hiding the dropdown.
    ///   - downScaleTransform: The scale transform applied when the dropdown appears.
    ///   - customCellType: An optional custom cell type if not using the default dropdown cell.
    ///   - customCellConfiguration: Configuration used to define the appearance of custom cells.
    public init(
        anchorView: AnchorView,
        bottomOffset: CGPoint = .zero,
        dataSource: [String] = [],
        cellHeight: CGFloat = 42,
        itemTextColor: UIColor? = .black,
        itemTextFont: UIFont = .boldSystemFont(ofSize: 13),
        selectedItemTextColor: UIColor? = nil,
        selectedItemBackgroundColor: UIColor? = .clear,
        separatorColor: UIColor? = .clear,
        tableViewBackgroundColor: UIColor? = .white,
        dimmedBackgroundColor: UIColor? = .clear,
        width: CGFloat? = nil,
        cornerRadius: CGFloat = 5,
        borderWidth: CGFloat = 1,
        borderColor: CGColor = UIColor.clear.cgColor,
        shadowColor: UIColor = .black,
        shadowOffset: CGSize = CGSize(width: 0, height: 4),
        shadowOpacity: Float = 0.03,
        shadowRadius: CGFloat = 4,
        animationduration: Double = 0.3,
        downScaleTransform: CGAffineTransform = CGAffineTransform(scaleX: 0.6, y: 0.6),
        customCellType: UITableViewCell.Type = BaseDropdownCell.self,
        customCellConfiguration: CellConfigurationClosure? = nil
    ) {
        self.anchorView = anchorView
        self.bottomOffset = bottomOffset
        self.dataSource = dataSource
        self.cellHeight = cellHeight
        self.itemTextColor = itemTextColor
        self.itemTextFont = itemTextFont
        self.selectedItemTextColor = selectedItemTextColor ?? itemTextColor
        self.selectedItemBackgroundColor = selectedItemBackgroundColor
        self.separatorColor = separatorColor
        self.tableViewBackgroundColor = tableViewBackgroundColor
        self.dimmedBackgroundColor = dimmedBackgroundColor
        self.width = width
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.shadowColor = shadowColor
        self.shadowOffset = shadowOffset
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.animationduration = animationduration
        self.downScaleTransform = downScaleTransform
        self.customCellType = customCellType
        self.customCellConfiguration = customCellConfiguration
        
        super.init(frame: .zero)
        
        configureAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAttributes() {
        backgroundColor = .clear
        
        dropdownTableView.register(customCellType, forCellReuseIdentifier: BaseDropdownCell.identifier)
        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
        dropdownTableView.rowHeight = cellHeight
        dropdownTableView.backgroundColor = .clear
        dropdownTableView.separatorColor = separatorColor
        dropdownTableView.layer.cornerRadius = cornerRadius
        dropdownTableView.clipsToBounds = true
        
        dropdownContainer.backgroundColor = tableViewBackgroundColor
        dropdownContainer.layer.cornerRadius = cornerRadius
        dropdownContainer.layer.borderWidth = borderWidth
        dropdownContainer.layer.borderColor = borderColor
        dropdownContainer.layer.shadowColor = shadowColor.cgColor
        dropdownContainer.layer.shadowOffset = shadowOffset
        dropdownContainer.layer.shadowOpacity = shadowOpacity
        dropdownContainer.layer.shadowRadius = shadowRadius
        dropdownContainer.clipsToBounds = true
        dropdownContainer.layer.masksToBounds = false

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hide))
        backgroundView.addGestureRecognizer(gestureRecognizer)
        backgroundView.backgroundColor = dimmedBackgroundColor
        
        configureLayout()
    }
}

// MARK: - Layout and Constraints Setup
extension Dropdown {
    private func configureLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        dropdownContainer.translatesAutoresizingMaskIntoConstraints = false
        dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundView)
        addSubview(dropdownContainer)
        dropdownContainer.addSubview(dropdownTableView)
        
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        updateDropdownContainerConstraints()
        
        dropdownTableView.topAnchor.constraint(equalTo: dropdownContainer.topAnchor).isActive = true
        dropdownTableView.leadingAnchor.constraint(equalTo: dropdownContainer.leadingAnchor).isActive = true
        dropdownTableView.bottomAnchor.constraint(equalTo: dropdownContainer.bottomAnchor).isActive = true
        dropdownTableView.trailingAnchor.constraint(equalTo: dropdownContainer.trailingAnchor).isActive = true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let shadowPath = UIBezierPath(roundedRect: dropdownContainer.bounds, cornerRadius: cornerRadius)
        dropdownContainer.layer.shadowPath = shadowPath.cgPath
    }
    
    /// Recalculates the layout of the dropdown based on the anchor view's layout.
    ///
    /// This method should be called after the layout of the anchor view is fully completed. It ensures that the dropdown's position is accurately calculated relative to the anchor view's finalized layout. This is crucial as the dropdown's placement is dependent on the anchor view's dimensions and position.
    public func updateDropdownLayout() {
        calculateDropdownLayout()
        removeDropdownLayout()
        updateDropdownContainerConstraints()
    }
    
    private func updateDropdownContainerConstraints() {
        dropdownTopConstraint = dropdownContainer.topAnchor.constraint(
            equalTo: self.topAnchor,
            constant: dropdownGeometry.y
        )
        dropdownTopConstraint?.isActive = true
        
        dropdownHeightConstraint = dropdownContainer.heightAnchor.constraint(equalToConstant: dropdownGeometry.height)
        dropdownHeightConstraint?.isActive = true
        
        dropdownLeadingConstraint = dropdownContainer.leadingAnchor.constraint(
            equalTo: self.leadingAnchor,
            constant: dropdownGeometry.x
        )
        dropdownLeadingConstraint?.isActive = true
        
        dropdownWidthConstraint = dropdownContainer.widthAnchor.constraint(equalToConstant: dropdownGeometry.width)
        dropdownWidthConstraint?.isActive = true
    }
    
    private func removeDropdownLayout() {
        dropdownTopConstraint?.isActive = false
        dropdownHeightConstraint?.isActive = false
        dropdownLeadingConstraint?.isActive = false
        dropdownWidthConstraint?.isActive = false
    }
}

// MARK: - Calculate Dropdown Position
extension Dropdown {
    /// Calculates the position and size of the dropdown, and checks if the dropdown can be displayed in the view.
    private func calculateDropdownLayout() {
        guard let window = UIWindow.visibleWindow() else { return }
        
        if anchorView is UIBarButtonItem {
            calculateDropdownPositionForBarButtonItem(window: window)
        } else {
            calculateDropdownPosition(window: window)
        }
        
        adjustDropdownWidthToFitSizeIfNecessary()
        adjustDropdownXPositionIfNecessary(window: window)
        
        let visibleHeight = tableHeight - dropdownGeometry.overflowHeight
        let isVisible = visibleHeight >= cellHeight

        dropdownGeometry.height = visibleHeight
        dropdownGeometry.visibleHeight = visibleHeight
        dropdownGeometry.isVisible = isVisible
    }

    /// Calculate Dropdown Position
    private func calculateDropdownPosition(window: UIWindow) {
        var overflowHeight: CGFloat = 0
        let calculatedWidth = width ?? (anchorView?.plainView.bounds.width ?? fittingWidth()) - bottomOffset.x
        
        let anchorViewX = anchorView?.plainView.windowFrame?.minX ?? window.frame.midX - (calculatedWidth / 2)
        let anchorViewY = anchorView?.plainView.windowFrame?.maxY ?? window.frame.midY - (tableHeight / 2)
        
        let x = anchorViewX + bottomOffset.x
        let y = anchorViewY + bottomOffset.y
        
        let maxY = y + tableHeight
        let windowMaxY = window.bounds.maxY

        if maxY > windowMaxY {
            overflowHeight = abs(maxY - windowMaxY) + 15
        }
        
        dropdownGeometry.x = x
        dropdownGeometry.y = y
        dropdownGeometry.width = calculatedWidth
        dropdownGeometry.overflowHeight = overflowHeight
    }
    
    /// Calculates dropdown position when the anchorView is a BarButton.
    private func calculateDropdownPositionForBarButtonItem(window: UIWindow) {
        var overflowHeight: CGFloat = 0
        let calculatedWidth = width ?? (anchorView?.plainView.bounds.width ?? fittingWidth()) - bottomOffset.x
        
        let anchorViewX = anchorView?.plainView.windowFrame?.minX ?? window.frame.midX - (calculatedWidth / 2)
        let anchorViewY = anchorView?.plainView.windowFrame?.maxY ?? window.frame.midY - (tableHeight / 2)
        
        let anchorViewRightX = anchorView?.plainView.windowFrame?.maxX ?? window.frame.midX + (calculatedWidth / 2)
        
        var x = anchorViewX
        
        let overflowWidth = x + calculatedWidth - window.bounds.maxX
        if overflowWidth > 0 {
            x -= overflowWidth + (window.bounds.maxX - anchorViewRightX)
        }
    
        x += bottomOffset.x
        let y = anchorViewY + bottomOffset.y
        
        let maxY = y + tableHeight
        let windowMaxY = window.bounds.maxY
        
        if maxY > windowMaxY {
            overflowHeight = abs(maxY - windowMaxY)
        }
        
        dropdownGeometry.x = x
        dropdownGeometry.y = y
        dropdownGeometry.width = calculatedWidth
        dropdownGeometry.overflowHeight = overflowHeight
    }
   
    /// Calculates and returns the width of the largest content item in the dropdown.
    private func fittingWidth() -> CGFloat {
        guard let templateCell = dropdownTableView.dequeueReusableCell(withIdentifier: BaseDropdownCell.identifier)
                as? BaseDropdownCell else { return .zero }

        let maxWidth = dataSource
            .map { text -> CGFloat in
                templateCell.optionLabel.text = text
                return templateCell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
            }
            .max()
        
        return maxWidth ?? .zero
    }
    
    /// Adjusts the dropdown's width if necessary to ensure it can display all item contents.
    private func adjustDropdownWidthToFitSizeIfNecessary () {
        guard width == nil else { return }
        dropdownGeometry.width = max(dropdownGeometry.width, fittingWidth())
    }
    
    /// Adjusts the X position of the dropdown if needed to ensure proper placement if it extends beyond the screen.
    private func adjustDropdownXPositionIfNecessary(window: UIWindow) {
        let windowMaxX = window.bounds.maxX
        let dropdownMaxX = dropdownGeometry.x + dropdownGeometry.width
        
        if dropdownMaxX > windowMaxX {
            let overflowWidth = dropdownMaxX - windowMaxX
            let adjustedDropdownX = dropdownGeometry.x - overflowWidth
            
            if adjustedDropdownX > 0 {
                dropdownGeometry.x = adjustedDropdownX
                
            } else {
                dropdownGeometry.x = 0
                dropdownGeometry.width += adjustedDropdownX
            }
        }
    }
}

// MARK: - Show & Hide
extension Dropdown {
    public func show() {
        guard dropdownGeometry.isVisible else { return }
        
        willShow?()
        configureDropdownLayout()
        
        if dropdownGeometry.overflowHeight > 0 {
            dropdownTableView.isScrollEnabled = true
            dropdownTableView.flashScrollIndicators()
        }
        
        dropdownContainer.transform = downScaleTransform
        
        UIView.animate(
            withDuration: animationduration,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.1,
            animations: { [weak self] in
                self?.alpha = 1
                self?.dropdownContainer.transform = .identity
            }
        )
    }
    
    @objc
    public func hide() {
        UIView.animate(
            withDuration: animationduration,
            animations: { [weak self] in
                self?.alpha = 0
                self?.dropdownContainer.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            },
            completion: { [weak self] _ in
                self?.removeFromSuperview()
            }
        )
        
        willHide?()
    }
    
    /// Dropdown Layout
    private func configureDropdownLayout() {
        let visibleWindow = UIWindow.visibleWindow() ?? UIWindow()
        visibleWindow.addSubview(self)
        visibleWindow.bringSubviewToFront(self)  // 드롭다운을 윈도우의 최상단으로 이동.

        leadingAnchor.constraint(equalTo: visibleWindow.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: visibleWindow.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: visibleWindow.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: visibleWindow.bottomAnchor).isActive = true
    }
}

// MARK: - UITableViewDataSource
extension Dropdown: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BaseDropdownCell.identifier,
            for: indexPath
        ) as? BaseDropdownCell else { return UITableViewCell() }
        
        cell.optionLabel.text = dataSource[indexPath.row]
        cell.optionLabel.textColor = itemTextColor
        cell.optionLabel.font = itemTextFont
        cell.normalTextColor = itemTextColor
        cell.selectedTextColor = selectedItemTextColor
        cell.selectedBackgroundColor = selectedItemBackgroundColor
        cell.selectionStyle = .none
        
        customCellConfiguration?(indexPath.row, dataSource[indexPath.row], cell)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension Dropdown: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.isSelected = selectedItemIndexRow == indexPath.row
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItemIndexRow = indexPath.row
        itemSelected?(dataSource[indexPath.row], indexPath.row)
    
        hide()
    }
}
