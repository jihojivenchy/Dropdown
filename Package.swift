// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
// 해당 버전은 패키지를 빌드 하는 데 필요한 Swift 컴파일러의 최소 버전

// manifest 파일이 패키지를 생성하는데 사용할 API를 포함하고 있는 라이브러리
import PackageDescription

let package = Package(
    name: "Dropdown",  // Dropdown 이라는 이름을 가진 패키지를 생성
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        // 제품은 패키지가 생성하는 실행 파일과 라이브러리를 정의하여 다른 패키지에서 볼 수 있도록 합니다.
        .library(
            name: "Dropdown",
            targets: ["Dropdown"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // 타겟은 모듈 또는 test suite를 정의하는 패키지의 기본 구성 요소입니다.
        // 타겟은 이 패키지의 다른 타겟과 종속성의 제품에 종속될 수 있습니다.
        .target(
            name: "Dropdown"),
        .testTarget(
            name: "DropdownTests",
            dependencies: ["Dropdown"]),
    ]
)
