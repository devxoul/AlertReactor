#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
import AlertReactor

enum MyAlertAction: AlertActionType {
  case edit
  case share
  case delete
  case cancel

  var title: String {
    switch self {
    case .edit: return "Edit"
    case .share: return "Share"
    case .delete: return "Delete"
    case .cancel: return "Cancel"
    }
  }

  var style: UIAlertAction.Style {
    switch self {
    case .edit: return .default
    case .share: return .default
    case .delete: return .destructive
    case .cancel: return .cancel
    }
  }
}

final class MyAlertReactor: AlertReactor<MyAlertAction> {
  let scheduler: SchedulerType

  init(scheduler: SchedulerType) {
    self.scheduler = scheduler
    super.init()
  }

  override func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .prepare:
      return Observable.concat([
        Observable.just(.setActions([.cancel])),
        Observable.just(.setActions([.edit, .cancel])).delay(.seconds(100), scheduler: self.scheduler),
        Observable.just(.setActions([.edit, .delete, .cancel])).delay(.seconds(100), scheduler: self.scheduler),
        Observable.just(.setActions([.edit, .share, .delete, .cancel])).delay(.seconds(100), scheduler: self.scheduler),
      ])

    case .selectAction:
      return .empty()
    }
  }
}
#endif
