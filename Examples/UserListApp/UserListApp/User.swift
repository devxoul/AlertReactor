//
//  User.swift
//  UserListApp
//
//  Created by Suyeol Jeon on 29/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

struct User {
  let id: String
  let name: String
  let email: String

  init?(json: [String: Any]) {
    guard let ids = json["id"] as? [String: Any] else { return nil }
    guard let id = ids["value"] as? String else { return nil }
    self.id = id

    guard let names = json["name"] as? [String: Any] else { return nil }
    guard let firstName = names["first"] as? String else { return nil }
    guard let lastName = names["last"] as? String else { return nil }
    self.name = firstName.capitalized + " " + lastName.capitalized

    guard let email = json["email"] as? String else { return nil }
    self.email = email
  }
}
