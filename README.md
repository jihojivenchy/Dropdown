## Dropdown
![License](https://img.shields.io/github/license/jihojivenchy/Dropdown)
![Version](https://img.shields.io/github/v/release/jihojivenchy/Dropdown)
![SPM supported](https://img.shields.io/badge/SPM-supported-brightgreen)

<img src = "https://github.com/jihojivenchy/Dropdown/assets/99619107/f14b4439-2728-4b17-a1f2-ac3af68d2f0a" height = 600>

## Introduction
A UIKit-based library that provides an easy-to-use and customizable dropdown menu.

<br>

## Installation
### Swift Package Manager
- file -> Swift Packages -> Add Package Dependency
- Add `https://github.com/jihojivenchy/Dropdown.git`
- Select "Up to Next Major" with "1.0.1"

<br>

## Basic Usage
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

### Adopting the Delegate
```
dropdown.delegate = self
```
- Assign the delegate.

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
| `animationduration` | The duration of the animation for showing and hiding the dropdown | `0.3` |
| `downScaleTransform` | The scale transform applied when the dropdown appears | `CGAffineTransform(scaleX: 0.6, y: 0.6)` |
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












