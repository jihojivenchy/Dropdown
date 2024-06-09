## Dropdown
![License](https://img.shields.io/github/license/jihojivenchy/Dropdown)
![Version](https://img.shields.io/github/v/release/jihojivenchy/Dropdown)
![SPM supported](https://img.shields.io/badge/SPM-supported-brightgreen)

### Slide & Scale Animation
<img src = "https://github.com/jihojivenchy/Dropdown/assets/99619107/b9747821-cac5-4e7a-b60e-a2a398524bbb" height = 600>
<img src = "https://github.com/jihojivenchy/Dropdown/assets/99619107/9c309652-b195-4684-b465-bb6b0e3076cb" height = 600>

## Introduction
A UIKit-based library that provides an easy-to-use and customizable dropdown menu.

<br>

## Installation
### Swift Package Manager
- file -> Swift Packages -> Add Package Dependency
- Add `https://github.com/jihojivenchy/Dropdown.git`
- Select "Up to Next Major" with "1.0.2"

<br>

## Basic Usage
```swift
import Dropdown
```

### Creating a Dropdown
```
lazy var dropdown: Dropdown = {
    let dropdown = Dropdown(anchorView: dropdownAnchorView)
    return dropdown
}()
```
- The dropdown calculates its position based on the anchorView, so make sure to set the anchor view during initialization.

<br>

### Calculating Dropdown Position (Important)
```
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    dropdown.updateDropdownLayout()
}
```
- The dropdown calculates its position based on the `anchorView`
- Therefore, call the `updateDropdownLayout` method when the layout of the `anchorView` is complete.
- The `viewDidAppear` method is an example. Feel free to call the method whenever the layout of the anchorView is done

<br>

### Setting the Data Source
```
lazy var dropdown: Dropdown = {
    let dropdown = Dropdown(anchorView: dropdownAnchorView)
    dropdown.dataSource = ["airplane", "car", "bus", "tram", "cablecar", "ferry"]
    return dropdown
}()
```
- Set the dataSource to configure the dropdown menu items.

<br>

### Adopting the Delegate (If you need)
```
dropdown.delegate = self
```
- Assign the delegate.

<br>

```
extension ViewController: DropdownDelegate {
    func willShow(_ sender: Dropdown) { }
    func willHide(_ sender: Dropdown) { }
    func itemSelected(_ sender: Dropdown, itemTitle: String, itemIndexRow: IndexRow) { }
}
```

- Adopt the `DropdownDelegate` protocol and define the desired methods for usage.
- Use the `sender` to differentiate between multiple Dropdown objects.

<br>

### DropdownAnimation (If you need)
```swift
public var animation: DropdownAnimation = DropdownAnimation()
```
- The dropdown animation can be customized using the `animation` property.

<br>

```swift
dropdown.animation = DropdownAnimation(type: .scale)
```
- You can set the dropdown animation by specifying the `DropdownAnimationType` as `.scale`.
- The default value is `.slide`.

<br>

```swift
dropdown.animation = DropdownAnimation(
    type: .scale,
    configuration: AnimationConfiguration(
        duration: 0.5, damping: 0.5, velocity: 0.5, downScaleTransform: CGAffineTransform(scaleX: 0.5, y: 0.5)
    )
)
```
- For more detailed settings, you can use `AnimationConfiguration`.
- `duration` = duration of the animation
- `damping` = damping ratio of the animation
- `velocity` = initial velocity of the animation
- `downScaleTransform` = transform used in the `.scale` animation (default value: 0.75)

<br>

## Advanced Usage

### Adjusting Dropdown Position with `bottomOffset`
```swift
dropdown.bottomOffset = CGPoint(x: 0, y: 0)
```
- You can adjust the position of the dropdown relative to the `anchorView` by using the `bottomOffset` property.
- The x value adjusts the horizontal position, moving the dropdown left or right.
- The y value adjusts the vertical position, moving the dropdown up or down.


<br>

### Applying Custom Cells
<img src = "https://github.com/jihojivenchy/Dropdown/assets/99619107/041edddd-4299-4f46-9b6f-6ffa2aff9e1c" height = 500>

- The left image shows the default Cell, while the right image shows a custom Cell created by the user.

<br>

1. Create a `CustomDropdownCell` that inherits from `BaseDropdownCell`
```swift
class CustomDropdownCell: BaseDropdownCell { }
```

<br>

2. Set up the layout
```swift
func configureLayouts() {
    contentView.addSubview(transportationImageView)
    contentView.addSubview(optionLabel)
    
    transportationImageView.snp.makeConstraints { make in
        make.centerY.equalToSuperview()
        make.left.equalToSuperview().inset(10)
        make.width.height.equalTo(25)
    }
    
    optionLabel.snp.makeConstraints { make in
        make.left.equalTo(transportationImageView.snp.right).offset(10)
        make.right.equalToSuperview().inset(15)
        make.centerY.equalToSuperview()
    }
}
```
- `optionLabel` is a `UILabel` provided by `BaseDropdownCell`.
- Feel free to arrange the layout to implement your `CustomDropdownCell`.

<br>

3. Register the `CustomDropdownCell`
```swift
lazy var dropdown: Dropdown = {
    let dropdown = Dropdown(
        anchorView: dropdownAnchorView,
        customCellType: CustomDropdownCell.self,
        customCellConfiguration: { [weak self] indexRow, _, cell in
            guard let self else { return }
            guard let cell = cell as? CustomDropdownCell else { return }
            // Cell Configure...
        }
    )
    return dropdown
}()
```

- You can provide `customCellType` and `customCellConfiguration` as parameters to the initializer of Dropdown.
- `customCellType` specifies the type of the custom cell, and `customCellConfiguration` configures the cell.

<br>


## Customization

| Name | Description | Default Value |
| --- | --- | --- |
| `cellHeight` | The height of each dropdown item | `42` |
| `itemTextColor` | The text color for dropdown items | `.black` |
| `itemTextFont` | The font of the text for dropdown items | `.boldSystemFont(ofSize: 13)` |
| `selectedItemTextColor` | The text color for a selected dropdown item | `nil` |
| `selectedItemBackgroundColor` | The background color for a selected dropdown item | `.clear` |
| `separatorColor` | The color of separators between dropdown items | `.clear` |
| `selectedItemIndexRow` | The index of the selected dropdown item | `nil` |
| `tableViewBackgroundColor` | The background color of the dropdown container | `.white` |
| `dimmedBackgroundColor` | The background color of the area behind the dropdown | `.clear` |
| `width` | The width of the dropdown | `nil` |
| `cornerRadius` | The corner radius of the dropdown | `5` |
| `borderWidth` | The border width of the dropdown container | `1` |
| `borderColor` | The border color of the dropdown container | `UIColor.clear.cgColor` |
| `shadowColor` | The shadow color of the dropdown container | `UIColor.black.cgColor` |
| `shadowOffset` | The shadow offset of the dropdown container | `CGSize(width: 0, height: 4)` |
| `shadowOpacity` | The shadow opacity of the dropdown container | `0.03` |
| `shadowRadius` | The shadow radius of the dropdown container | `4` |


### License
Dropdown is available under the MIT license.










