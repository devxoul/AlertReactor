import UIKit

public protocol AlertActionType: Equatable {
  var title: String { get }
  var style: UIAlertActionStyle { get }
  var isEnabled: Bool { get }
}

public extension AlertActionType {
  var style: UIAlertActionStyle {
    return .default
  }

  var isEnabled: Bool {
    return true
  }
}

public extension UIAlertAction {
  public convenience init<Action: AlertActionType>(action: Action, handler: ((Action) -> Void)? = nil) {
    self.init(title: action.title, style: action.style) { _ in handler?(action) }
    self.isEnabled = action.isEnabled
  }
}
