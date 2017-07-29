//
//  UserAlertAction.swift
//  UserListApp
//
//  Created by Suyeol Jeon on 29/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import AlertReactor

enum UserAlertAction: AlertActionType {
  case loading
  case copy
  case follow
  case unfollow
  case block
  case cancel

  var title: String {
    switch self {
    case .loading: return "Loading..."
    case .copy: return "Copy"
    case .follow: return "Follow"
    case .unfollow: return "Unfollow"
    case .block: return "Block"
    case .cancel: return "Cancel"
    }
  }

  var style: UIAlertActionStyle {
    switch self {
    case .loading: return .default
    case .copy: return .default
    case .follow: return .default
    case .unfollow: return .destructive
    case .block: return .destructive
    case .cancel: return .cancel
    }
  }

  var isEnabled: Bool {
    switch self {
    case .loading: return false
    default: return true
    }
  }
}
