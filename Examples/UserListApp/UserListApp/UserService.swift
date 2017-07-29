//
//  UserService.swift
//  UserListApp
//
//  Created by Suyeol Jeon on 29/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import RxSwift

struct UserService {
  private static var followingStatus: [String: Bool] = [:]

  static func users() -> Observable<[User]> {
    guard let url = URL(string: "https://randomuser.me/api/?results=30") else { return .just([]) }
    return URLSession.shared.rx.json(url: url)
      .map { json -> [User] in
        guard let dict = json as? [String: Any] else { return [] }
        guard let results = dict["results"] as? [[String: Any]] else { return [] }
        return results.flatMap(User.init)
      }
  }

  static func isFollowing(userID: String) -> Observable<Bool> {
    let isFollowing = self.followingStatus[userID] ?? false
    let randomTime = 1 + TimeInterval(arc4random() % 2)
    return Observable.just(isFollowing).delay(randomTime, scheduler: MainScheduler.instance)
  }

  static func follow(userID: String) -> Observable<Void> {
    self.followingStatus[userID] = true
    return .just()
  }

  static func unfollow(userID: String) -> Observable<Void> {
    self.followingStatus[userID] = false
    return .just()
  }
}
