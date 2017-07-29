//
//  UserCell.swift
//  UserListApp
//
//  Created by Suyeol Jeon on 29/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

final class UserCell: UITableViewCell, View {
  var disposeBag = DisposeBag()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    self.detailTextLabel?.textColor = .gray
    self.accessoryType = .disclosureIndicator
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func bind(reactor: UserCellReactor) {
    guard let textLabel = self.textLabel else { return }
    guard let detailTextLabel = self.detailTextLabel else { return }

    // State
    reactor.state.map { $0.name }
      .distinctUntilChanged()
      .bind(to: textLabel.rx.text)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.email }
      .distinctUntilChanged()
      .bind(to: detailTextLabel.rx.text)
      .disposed(by: self.disposeBag)
  }
}
