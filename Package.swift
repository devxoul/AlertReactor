// swift-tools-version:4.0

import PackageDescription

let package = Package(
  name: "AlertReactor",
  products: [
    .library(name: "AlertReactor", targets: ["AlertReactor"]),
  ],
  dependencies: [
    .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "4.0.0")),
    .package(url: "https://github.com/ReactorKit/ReactorKit.git", .upToNextMajor(from: "1.0.0")),
    .package(url: "https://github.com/devxoul/RxExpect.git", .upToNextMajor(from: "1.0.0")),
  ],
  targets: [
    .target(name: "AlertReactor", dependencies: ["ReactorKit", "RxCocoa"]),
    .testTarget(name: "AlertReactorTests", dependencies: ["AlertReactor", "RxExpect"]),
  ]
)
