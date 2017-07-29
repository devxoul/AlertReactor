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
        Observable.just(.setActions([.copy, .loading, .block, .cancel])),
        UserService.isFollowing(userID: self.userID)
          .map { isFollowing -> [UserAlertAction] in
            let followOrUnfollow: UserAlertAction = !isFollowing ? .follow : .unfollow
            return [.copy, followOrUnfollow, .block, .cancel]
          }
          .map(Mutation.setActions),
      ])

    case let .selectAction(alertAction):
      switch alertAction {
      case .loading:
        return .empty()
      case .copy:
        return .empty()
      case .follow:
        return UserService.follow(userID: self.userID).flatMap(Observable.empty)
      case .unfollow:
        return UserService.unfollow(userID: self.userID).flatMap(Observable.empty)
      case .block:
        return .empty()
      case .cancel:
        return .empty()
      }
    }
  }
}
