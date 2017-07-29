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
