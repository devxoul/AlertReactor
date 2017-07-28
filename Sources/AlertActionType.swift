import UIKit

public protocol AlertActionType: Equatable {
  var title: String { get }
  var style: UIAlertActionStyle { get }
}

public extension AlertActionType {
  var style: UIAlertActionStyle {
    return .default
  }
}
