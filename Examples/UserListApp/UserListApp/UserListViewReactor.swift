//
//  UserListViewReactor.swift
//  UserListApp
//
//  Created by Suyeol Jeon on 29/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxSwift

final class UserListViewReactor: Reactor {
  enum Action {
    case refresh
  }

  enum Mutation {
    case setRefreshing(Bool)
    case setUsers([User])
  }

  struct State {
    var isRefreshing: Bool
    var users: [UserCellReactor]
  }

  let initialState: State

  init() {
    self.initialState = State(isRefreshing: false, users: [])
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refresh:
      return Observable.concat([
        Observable.just(.setRefreshing(true)),
        UserService.users().map(Mutation.setUsers),
        Observable.just(.setRefreshing(false)),
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setRefreshing(isRefreshing):
      state.isRefreshing = isRefreshing
      return state

    case let .setUsers(users):
      state.users = users.map(UserCellReactor.init)
      return state
    }
  }
}
