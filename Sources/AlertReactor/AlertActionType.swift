#if os(iOS) || os(tvOS)
import UIKit

public protocol AlertActionType: Equatable {
  var title: String { get }
  var style: UIAlertAction.Style { get }
  var isEnabled: Bool { get }
}

public extension AlertActionType {
  var style: UIAlertAction.Style {
    return .default
  }

  var isEnabled: Bool {
    return true
  }
}

public extension UIAlertAction {
  convenience init<Action: AlertActionType>(action: Action, handler: ((Action) -> Void)? = nil) {
    self.init(title: action.title, style: action.style) { _ in handler?(action) }
    self.isEnabled = action.isEnabled
  }
}
#endif
