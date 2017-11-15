#if os(iOS) || os(tvOS)
import UIKit

import ReactorKit
import RxCocoa
import RxSwift


// MARK: - AlertControllerType

public protocol AlertControllerType: class {
  associatedtype AlertAction: AlertActionType

  var _actionSelectedSubject: PublishSubject<AlertAction> { get }
  var actions: [UIAlertAction] { get }

  func addAction(_ action: UIAlertAction)
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
    defer { self.reactor = reactor }
    self._preferredStyle = preferredStyle
    super.init(nibName: nil, bundle: nil)
    self.title = ""
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

    self.rx.actionSelected
      .map(Reactor.Action.selectAction)
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

    reactor.state
      .subscribe(onNext: { [weak self] _ in
        guard let view = self?.view else { return }
        let selector = NSSelectorFromString("_contentSizeChanged")
        if view.responds(to: selector) {
          _ = view.perform(selector)
        }
      })
      .disposed(by: self.disposeBag)
  }
}


// MARK: - Reactive Extension

extension Reactive where Base: AlertControllerType {
  public var actionSelected: ControlEvent<Base.AlertAction> {
    let source = self.base._actionSelectedSubject.asObservable()
    return ControlEvent(events: source)
  }

  public var actions: Binder<[Base.AlertAction]> {
    return Binder(self.base) { alertController, actions in
      // do nothing if both old actions and new actions are empty
      guard !(alertController.actions.isEmpty && actions.isEmpty) else { return }

      // [AlertActionType] -> [UIAlertAction]
      let alertActions = actions.map { action -> UIAlertAction in
        UIAlertAction(action: action) { [weak base = self.base] action in
          base?._actionSelectedSubject.onNext(action)
        }
      }

      // prepare action views
      self.prepareActionViews(with: alertActions, for: .default)
      self.prepareActionViews(with: alertActions, for: .cancel)
      self.prepareActionViews(with: alertActions, for: .destructive)

      // set actions
      alertController.setValue(alertActions, forKey: "actions")
    }
  }

  private func prepareActionViews(with newActions: [UIAlertAction], for style: UIAlertActionStyle) {
    let oldActions = self.base.actions
    let oldCount = oldActions.filter { $0.style == style }.count
    let newCount = newActions.filter { $0.style == style }.count
    let diff = newCount - oldCount
    if diff > 0 {
      for _ in 0..<diff {
        let placeholderAction = UIAlertAction(title: "", style: style, handler: nil)
        self.base.addAction(placeholderAction)
      }
    }
  }
}
#endif
