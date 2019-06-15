// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "AlertReactor",
  platforms: [
    .iOS(.v8)
  ],
  products: [
    .library(name: "AlertReactor", targets: ["AlertReactor"]),
  ],
  dependencies: [
    .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "5.0.0")),
    .package(url: "https://github.com/ReactorKit/ReactorKit.git", .upToNextMajor(from: "2.0.0")),
    .package(url: "https://github.com/devxoul/RxExpect.git", .upToNextMajor(from: "2.0.0")),
  ],
  targets: [
    .target(name: "AlertReactor", dependencies: ["ReactorKit", "RxCocoa"]),
    .testTarget(name: "AlertReactorTests", dependencies: ["AlertReactor", "RxExpect"]),
  ]
)
