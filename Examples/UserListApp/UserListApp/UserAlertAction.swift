//
//  UserAlertAction.swift
//  UserListApp
//
//  Created by Suyeol Jeon on 29/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import AlertReactor

enum UserAlertAction: AlertActionType {
  static var cancelAction: UserAlertAction { return .cancel }

  case follow
  case unfollow
  case cancel

  var title: String {
    switch self {
    case .follow: return "Follow"
    case .unfollow: return "Unfollow"
    case .cancel: return "Cancel"
    }
  }

  var style: UIAlertActionStyle {
    switch self {
    case .follow: return .default
    case .unfollow: return .destructive
    case .cancel: return .cancel
    }
  }
}
