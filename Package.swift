// swift-tools-version:3.1

import Foundation
import PackageDescription

var dependencies: [Package.Dependency] = [
  .Package(url: "https://github.com/ReactiveX/RxSwift.git", majorVersion: 3),
  .Package(url: "https://github.com/ReactorKit/ReactorKit.git", majorVersion: 0),
]

let isTest = ProcessInfo.processInfo.environment["TEST"] == "1"
if isTest {
  dependencies.append(
    .Package(url: "https://github.com/devxoul/RxExpect.git", majorVersion: 0)
  )
}

let package = Package(
  name: "AlertReactor",
  dependencies: dependencies
)
