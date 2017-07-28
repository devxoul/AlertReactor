# AlertReactor

![Swift](https://img.shields.io/badge/Swift-3.1-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/AlertReactor.svg)](https://cocoapods.org/pods/AlertReactor)
[![Build Status](https://travis-ci.org/devxoul/AlertReactor.svg?branch=master)](https://travis-ci.org/devxoul/AlertReactor)
[![Codecov](https://img.shields.io/codecov/c/github/devxoul/AlertReactor.svg)](https://codecov.io/gh/devxoul/AlertReactor)

ReactorKit extension for UIAlertController. It provides an elegant way to deal with an UIAlertController. Best fits for lazy-loaded alert actions.

## Features

* Statically typed alert actions
* Reactive and dynamic action bindings

## At a Glance

With AlertReactor, you can write a reactive code for alert controller. The code below displays an action sheet when `menuButton` is tapped. When an user selects an item in the action sheet, the selected menu item is converted into an action which is binded to a reactor.

```swift
// Menu Button -> Action Sheet -> Reactor Action
menuButton.rx.tap
  .flatMap { [weak self] _ -> Observable<UserAlertAction> in
    let reactor = UserAlertReactor()
    let controller = AlertController<UserAlertAction>(reactor: reactor, preferredStyle: .actionSheet)
    self?.present(controller, animated: true, completion: nil)
    return controller.rx.actionSelected.asObservable()
  }
  .map { alertAction -> Reactor.Action? in
    switch action {
      case .follow: return .followUser
      case .unfollow: return .unfollowUser
      case .block: return .blockUser
      case .cancel: return nil
    }
  }
  .filterNil()
  .bind(to: reactor.action)
```

## Getting Started

### 1. Defining an Alert Action

AlertReactor provides a `AlertActionType ` protocol. This is an abstraction model of `UIAlertAction`. Create a new type conforming this protocol. This protocol requires a `title` and `style` property.

```swift
enum UserAlertAction: AlertActionType {
  case follow
  case unfollow
  case block
  case cancel

  // required
  var title: String {
    case follow: return "Follow"
    case unfollow: return "Unfollow"
    case block: return "Block"
    case cancel: return "Cancel"
  }

  // optional
  var style: UIAlertActionStyle {
    case follow: return .default
    case unfollow: return .default
    case block: return .destructive
    case cancel: return .cancel
  }
}
```


### 2. Creating an Alert Reactor

`AlertReactor` is a reactor class. It has an action, mutation and state:

```swift
enum Action {
  case prepare
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
```

Override this class to implement `mutate(action:)` method so that the reactor can emit mutations to change the state. Here is an example of lazy-loaded actions.

```swift
final class UserAlertReactor: AlertReactor<UserAlertAction> {
  let userID: Int

  init(userID: Int) {
    self.userID = userID
  }

  override func mutate(action: Action) -> Observable<Mutation> {
    return Observable.concat([
      // Initial actions
      Observable.just(Mutation.setTitle("Loading...")),
      Observable.just(Mutation.setActions([.block, .cancel])),

      // Call API to choose follow or unfollow
      api.isFollowing(userID: userID)
        .map { isFollowing -> Mutation in
          if isFollowing {
            return Mutation.setActions([.unfollow, .block, .cancel])
          } else {
            return Mutation.setActions([.follow, .block, .cancel])
          }
        }
      Observable.just(Mutation.setTitle(nil)),
    ])
  }
}
```

### 3. Using with Alert Controller

A generic class `AlertController` is provided. You can create it with some parameters: `reactor` and `preferredStyle`. There's also a `actionSelected` control event property in a reactive extension.

```swift
let reactor = UserAlertReactor(userID: 12345)
let controller = AlertController<UserAlertAction>(reactor: reactor, preferredStyle: .actionSheet)
controller.rx.actionSelected
  .subscribe(onNext: { action in
    switch action {
      case .follow: print("Follow user")
      case .unfollow: print("Unfollow user")
      case .block: print("Block user")
      case .cancel: print("Cancel")
    }
  })
```

## Installation

```ruby
pod 'AlertReactor'
```

## License

AlertReactor is under MIT license. See the [LICENSE](LICENSE) for more info.
