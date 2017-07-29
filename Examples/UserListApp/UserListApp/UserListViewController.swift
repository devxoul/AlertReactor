//
//  UserListViewController.swift
//  UserListApp
//
//  Created by Suyeol Jeon on 29/07/2017.
//  Copyright © 2017 Suyeol Jeon. All rights reserved.
//

import AlertReactor
import ReactorKit
import RxSwift

class UserListViewController: UIViewController, View {

  var disposeBag = DisposeBag()
  let tableView = UITableView()
  let refreshControl = UIRefreshControl()

  init(reactor: UserListViewReactor) {
    super.init(nibName: nil, bundle: nil)
    self.title = "Random Users"
    self.reactor = reactor
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.register(UserCell.self, forCellReuseIdentifier: "userCell")
    self.view.addSubview(self.tableView)
    self.tableView.addSubview(self.refreshControl)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.tableView.frame = self.view.bounds
  }

  func bind(reactor: UserListViewReactor) {
    // Action
    self.rx.methodInvoked(#selector(UIViewController.viewDidLoad))
      .map { _ in Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.refreshControl.rx.controlEvent(.valueChanged)
      .map { _ in Reactor.Action.refresh }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // State
    reactor.state.map { $0.isRefreshing }
      .bind(to: self.refreshControl.rx.isRefreshing)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.users }
      .bind(to: self.tableView.rx.items(cellIdentifier: "userCell", cellType: UserCell.self)) { row, cellReactor, cell in
        cell.reactor = cellReactor
      }
      .disposed(by: self.disposeBag)

    // View
    self.tableView.rx.modelSelected(UserCellReactor.self)
      .subscribe(onNext: { [weak self] cellReactor in
        guard let `self` = self else { return }
        let reactor = UserAlertReactor(userID: cellReactor.currentState.id)
        let controller = AlertController<UserAlertAction>(
          reactor: reactor,
          preferredStyle: .actionSheet
        )
        self.present(controller, animated: true, completion: nil)
      })
      .disposed(by: self.disposeBag)

    self.tableView.rx.itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        self?.tableView.deselectRow(at: indexPath, animated: true)
      })
      .disposed(by: self.disposeBag)
  }
}
