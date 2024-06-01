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
    /// The height of each dropdown item.
    public var cellHeight: CGFloat = 42 {
        willSet { dropdownTableView.rowHeight = newValue }
        didSet { dropdownTableView.reloadData() }
    }
    
    /// The text color for dropdown items.
    public var itemTextColor: UIColor = .black {
        didSet { dropdownTableView.reloadData() }
    }
    
    /// The font of the text for dropdown items.
    public var itemTextFont: UIFont = .boldSystemFont(ofSize: 13) {
        didSet { dropdownTableView.reloadData() }
    }
    
    /// The text color for a selected dropdown item.
    public var selectedItemTextColor: UIColor? = nil {
        didSet { dropdownTableView.reloadData() }
    }
    
    /// The background color for a selected dropdown item.
    public var selectedItemBackgroundColor: UIColor = .clear {
        didSet { dropdownTableView.reloadData() }
    }
    
    /// The color of separators between dropdown items.
    public var separatorColor: UIColor? = .clear {
        didSet { dropdownTableView.reloadData() }
    }
    
    // MARK: - UI Properties
    /// The background color of the dropdown container.
    /// - Note: Use this property to set the color of the dropdown's table view.
    public var tableViewBackgroundColor: UIColor? = .white {
        willSet { dropdownContainer.backgroundColor = newValue }
    }
    
    /// The background color of the area behind the dropdown.
    /// - Note: Use this property to set the color that appears behind the dropdown when it is presented.
    public var dimmedBackgroundColor: UIColor? = .clear {
        willSet { backgroundView.backgroundColor = newValue }
    }
    
    private var tableHeight: CGFloat {
        return dropdownTableView.rowHeight * CGFloat(dataSource.count)
    }
    
    /// The width of the dropdown
    public var width: CGFloat? = nil {
        didSet { updateDropdownLayout() }
    }
    
    public var cornerRadius: CGFloat = 5 {
        willSet { dropdownTableView.layer.cornerRadius = newValue }
    }
    
    public var borderWidth: CGFloat = 1 {
        willSet { dropdownContainer.layer.borderWidth = newValue }
    }
    
    public var borderColor: CGColor = UIColor.clear.cgColor {
        willSet { dropdownContainer.layer.borderColor = newValue }
    }
    
    public var shadowColor: CGColor = UIColor.black.cgColor {
        willSet { dropdownContainer.layer.shadowColor = newValue }
    }
    
    public var shadowOffset: CGSize = CGSize(width: 0, height: 4) {
        willSet { dropdownContainer.layer.shadowOffset = newValue }
    }
    
    public var shadowOpacity: Float = 0.03 {
        willSet { dropdownContainer.layer.shadowOpacity = newValue }
    }
    
    public var shadowRadius: CGFloat = 4 {
        willSet { dropdownContainer.layer.shadowRadius = newValue }
    }
    
    // MARK: - Dropdown Layout Properties
    private var dropdownTopConstraint: NSLayoutConstraint?
    private var dropdownHeightConstraint: NSLayoutConstraint?
    private var dropdownLeadingConstraint: NSLayoutConstraint?
    private var dropdownWidthConstraint: NSLayoutConstraint?
    
    /**
    The offset point relative to `anchorView` when the drop down is shown below the anchor view.

    By default, the drop down is showed onto the `anchorView` with the top
    left corner for its origin, so an offset equal to (0, 0).
    You can change here the default drop down origin.
    */
    public var bottomOffset: CGPoint = .zero {
        didSet { updateDropdownLayout() }
    }
    
    // MARK: - Animation
    /// The duration of the animation for showing and hiding the dropdown.
    public var animationduration: Double = 0.3
    
    /// The scale transform applied when the dropdown appears.
    public var downScaleTransform: CGAffineTransform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    
    
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
    /// The source of data for dropdown items.
    public var dataSource: [String] = [] {
        didSet {
            updateDropdownLayout()
            dropdownTableView.reloadData()
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
    ///   - customCellType: An optional custom cell type if not using the default dropdown cell.
    ///   - customCellConfiguration: Configuration used to define the appearance of custom cells.
    public init(
        anchorView: AnchorView,
        customCellType: UITableViewCell.Type = BaseDropdownCell.self,
        customCellConfiguration: CellConfigurationClosure? = nil
    ) {
        self.anchorView = anchorView
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
        dropdownContainer.layer.shadowColor = shadowColor
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
        let labelMargin: CGFloat = 30  // 15 points on each side
        
        let maxWidth = dataSource.map { text -> CGFloat in
            let textWidth = (text as NSString).size(withAttributes: [.font: itemTextFont]).width
            return textWidth + labelMargin
        }.max()
        
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
        visibleWindow.bringSubviewToFront(self)

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
        
        // This ensures that custom cell configuration is used when available,
        // and defaults to the cell's layout configuration to avoid layout conflicts.
        if let cellConfiguration = customCellConfiguration {
            cellConfiguration(indexPath.row, dataSource[indexPath.row], cell)
        } else {
            // If customCellConfiguration does not exist, configure the cell with default layouts.
            cell.configureLayouts()
        }

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
