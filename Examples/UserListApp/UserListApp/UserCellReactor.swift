//
//  UserCellReactor.swift
//  UserListApp
//
//  Created by Suyeol Jeon on 29/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import ReactorKit
import RxSwift

final class UserCellReactor: Reactor {
  enum Action {
  }

  enum Mutation {
  }

  struct State {
    let id: String
    var name: String
    var email: String
  }

  let initialState: State

  init(user: User) {
    self.initialState = State(id: user.id, name: user.name, email: user.email)
  }
}
