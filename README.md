# AlertReactor

![Swift](https://img.shields.io/badge/Swift-3.1-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/AlertReactor.svg)](https://cocoapods.org/pods/AlertReactor)
[![Build Status](https://travis-ci.org/devxoul/AlertReactor.svg?branch=master)](https://travis-ci.org/devxoul/AlertReactor)
[![Codecov](https://img.shields.io/codecov/c/github/devxoul/AlertReactor.svg)](https://codecov.io/gh/devxoul/AlertReactor)

AlertReactor is a ReactorKit extension for UIAlertController. It provides an elegant way to deal with an UIAlertController. Best fits if you have lazy-loaded alert actions.

![alertreactor](https://user-images.githubusercontent.com/931655/28745788-ab587fbe-74ba-11e7-9c41-d3dfac34f255.png)

## Features

* ✏️ Statically typed alert actions
* 🕹 Reactive and dynamic action bindings

## At a Glance

This is an example implementation of an `AlertReactor`:

```swift
final class UserAlertReactor: AlertReactor<UserAlertAction> {
  override func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .prepare:
      return .just(.setActions([.copy, .follow, .block, .cancel]))

    case let .selectAction(alertAction):
      switch alertAction {
      case .copy: return foo()
      case .follow: return foo()
      case .unfollow: return foo()
      case .block: return foo()
      case .cancel: return foo()
      }
    }
  }
}
```

## Getting Started

### 1. Defining an Alert Action

First you should define a new type which conforms to a protocol `AlertActionType`. This is an abstraction model of `UIAlertAction`. This protocol requires a `title`(required), `style`(optional) and `isEnabled`(optional) property.

```swift
enum UserAlertAction: AlertActionType {
  case loading
  case follow
  case block
  case cancel

  // required
  var title: String {
    switch self {
    case .loading: return "Loading"
    case .follow: return "Follow"
    case .block: return "Block"
    case .cancel: return "Cancel"
    }
  }

  // optional
  var style: UIAlertActionStyle {
    switch self {
    case .loading: return .default
    case .follow: return .default
    case .block: return .destructive
    case .cancel: return .cancel
    }
  }

  // optional
  var isEnabled: Bool {
    switch self {
    case .loading: return false
    default: return true
    }
  }
}
```


### 2. Creating an Alert Reactor

`AlertReactor` is a generic reactor class. It takes a single generic type which conforms to a protocol `AlertActionType`. This reactor provides a default action, mutation and a state. Here is a simplified definition of `AlertReactor`. You may subclass this class and override `mutate(action:)` method to implement specific business logic.

```swift
class AlertReactor<AlertAction: AlertActionType>: Reactor {
  enum Action {
    case prepare // on viewDidLoad()
    case selectAction(AlertAction) // on select action
  }

  enum Mutation {
    case setTitle(String?)
    case setMessage(String?)
    case setActions([AlertAction])
  }

  struct State {
    public var title: String?
    public var message: String?
    public var actions: [AlertAction]
  }
}
```

We're gonna use the `UserAlertAction` as a generic parameter to create a new subclass of `AlertReactor`.

```swift
final class UserAlertReactor: AlertReactor<UserAlertAction> {
  override func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .prepare:
      return .just(Mutation.setActions([.copy, .follow, .block, .cancel]))

    case let .selectAction(alertAction):
      switch alertAction {
      case .loading: return .empty()
      case .follow: return UserAPI.follow()
      case .block: return UserAPI.block()
      case .cancel: return .empty()
      }
    }
  }
}
```

### 3. Presenting an Alert Controller

`AlertController` is a subclass of `UIAlertController` which conforms to a protocol `View` from ReactorKit. This class also takes a single generic type of `AlertActionType`. You can initialize this class with some optional parameters: `reactor` and `preferredStyle`. Just present it then the reactor will handle the business logic for you.

```swift
let reactor = UserAlertReactor()
let controller = AlertController<UserAlertAction>(reactor: reactor, preferredStyle: .actionSheet)
self.present(controller, animated: true, completion: nil)
```

## Installation

```ruby
pod 'AlertReactor'
```

## License

AlertReactor is under MIT license. See the [LICENSE](LICENSE) for more info.
