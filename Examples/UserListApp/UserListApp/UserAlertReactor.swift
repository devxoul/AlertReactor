//
//  UserAlertReactor.swift
//  UserListApp
//
//  Created by Suyeol Jeon on 29/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import AlertReactor
import ReactorKit
import RxSwift

final class UserAlertReactor: AlertReactor<UserAlertAction> {
  fileprivate let userID: String
  init(userID: String) {
    self.userID = userID
  }

  override func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .prepare:
      return Observable.concat([
        Observable.just(.setTitle("Loading...")),
        Observable.just(.setMessage("Wait for a second")),
        Observable.just(.setActions([.cancel])),
        UserService.isFollowing(userID: self.userID)
          .map { isFollowing -> [UserAlertAction] in
            if !isFollowing {
              return [.follow, .cancel]
            } else {
              return [.unfollow, .cancel]
            }
          }
          .flatMap { actions -> Observable<Mutation> in
            Observable.concat([
              Observable.just(.setActions(actions)),
              Observable.just(.setTitle("Select an action")),
              Observable.just(.setMessage(nil)),
            ])
          },
      ])

    case let .selectAction(alertAction):
      switch alertAction {
      case .follow:
        return UserService.follow(userID: self.userID).flatMap(Observable.empty)
      case .unfollow:
        return UserService.unfollow(userID: self.userID).flatMap(Observable.empty)
      case .cancel:
        return .empty()
      }
    }
  }
}
