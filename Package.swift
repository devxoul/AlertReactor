// swift-tools-version:4.0

import PackageDescription

let package = Package(
  name: "AlertReactor",
  products: [
    .library(name: "AlertReactor", targets: ["AlertReactor"]),
  ],
  dependencies: [
    .package(url: "https://github.com/ReactiveX/RxSwift.git", .branch("rxswift4.0-swift4.0")),
    .package(url: "https://github.com/ReactorKit/ReactorKit.git", .branch("swift-4.0")),
    .package(url: "https://github.com/devxoul/RxExpect.git", .branch("swift-4.0")),
  ],
  targets: [
    .target(name: "AlertReactor", dependencies: ["ReactorKit", "RxCocoa"]),
    .testTarget(name: "AlertReactorTests", dependencies: ["AlertReactor", "RxExpect"]),
  ]
)
