## Dropdown
![License](https://img.shields.io/github/license/jihojivenchy/Dropdown)
![Version](https://img.shields.io/github/v/release/jihojivenchy/Dropdown)
![SPM supported](https://img.shields.io/badge/SPM-supported-brightgreen)

<img src = "https://github.com/jihojivenchy/Dropdown/assets/99619107/f14b4439-2728-4b17-a1f2-ac3af68d2f0a" height = 600>

## 소개
사용하기 쉽고 커스텀 가능한 드롭다운 메뉴를 제공하는 UIKit 기반의 라이브러리입니다.

<br>

## Installation
### Swift Package Manager
- file -> Swift Packages -> Add Package Dependency
- Add `https://github.com/jihojivenchy/Dropdown.git`
- Select "Up to Next Major" with "1.0.1"


## 사용방법
### 드롭다운 생성하기
```
lazy var dropdown: Dropdown = {
    let dropdown = Dropdown(anchorView: dropdownAnchorView)
    return dropdown
}()
```
- 드롭다운은 `anchorView`를 기준으로 위치를 계산하기 때문에 초기화를 할 때, 꼭 앵커뷰를 설정해줘야 합니다.

<br>

### 드롭다운 위치 계산하기
```
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    dropdown.updateDropdownLayout()
}
```
- 드롭다운은 'anchorView'를 기준으로 위치를 계산합니다.
- 따라서 anchorView의 레이아웃이 완료된 시점에 `updateDropdownLayout` 메서드를 호출해서 위치를 계산해줍니다.
- `viewDidAppear`는 예시입니다. anchorView의 레이아웃이 완료된 시점을 찾아 자유롭게 메서드를 호출해주세요.








