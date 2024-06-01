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

















