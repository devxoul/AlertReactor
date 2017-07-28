import UIKit

import ReactorKit
import RxCocoa
import RxSwift


// MARK: - AlertControllerType

public protocol AlertControllerType: class {
  associatedtype AlertAction: AlertActionType
  var _actionSelectedSubject: PublishSubject<AlertAction> { get }
  func setValue(_ value: Any?, forKey key: String)
}


// MARK: - AlertController

open class AlertController<A: AlertActionType>: UIAlertController, AlertControllerType, View {
  public typealias AlertAction = A


  // MARK: Properties

  open var disposeBag = DisposeBag()
  public private(set) lazy var _actionSelectedSubject: PublishSubject<AlertAction> = .init()

  private var _preferredStyle: UIAlertControllerStyle
  open override var preferredStyle: UIAlertControllerStyle {
    get { return self._preferredStyle }
    set { self._preferredStyle = newValue }
  }


  // MARK: Initializing

  public init(reactor: AlertReactor<AlertAction>? = nil, preferredStyle: UIAlertControllerStyle = .alert) {
    self._preferredStyle = preferredStyle
    super.init(nibName: nil, bundle: nil)
    self.title = ""
    self.reactor = reactor
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Binding

  open func bind(reactor: AlertReactor<AlertAction>) {
    // Action
    self.rx.methodInvoked(#selector(UIViewController.viewDidLoad))
      .map { _ in Reactor.Action.prepare }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // State
    reactor.state.map { $0.title }
      .distinctUntilChanged { $0 == $1 }
      .subscribe(onNext: { [weak self] title in
        self?.title = title
      })
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.message }
      .distinctUntilChanged { $0 == $1 }
      .subscribe(onNext: { [weak self] message in
        self?.message = message
      })
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.actions }
      .distinctUntilChanged { old, new in
        old.elementsEqual(new) { $0.title == $1.title && $0.style == $1.style }
      }
      .bind(to: self.rx.actions)
      .disposed(by: self.disposeBag)
  }
}


// MARK: - Reactive Extension

extension Reactive where Base: AlertControllerType {
  var actions: UIBindingObserver<Base, [Base.AlertAction]> {
    return UIBindingObserver(UIElement: self.base) { alertController, actions in
      let alertActions = actions.map { action in
        UIAlertAction(title: action.title, style: action.style) { [weak base = self.base] _ in
          base?._actionSelectedSubject.onNext(action)
        }
      }
      alertController.setValue(alertActions, forKey: "actions")
    }
  }

  var actionSelected: ControlEvent<Base.AlertAction> {
    let source = self.base._actionSelectedSubject.asObservable()
    return ControlEvent(events: source)
  }
}
