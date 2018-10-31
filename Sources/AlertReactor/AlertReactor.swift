#if os(iOS) || os(tvOS)
import ReactorKit
import RxSwift

open class AlertReactor<AlertAction: AlertActionType>: Reactor {
  public typealias Action = _Action<AlertAction>
  public enum _Action<AlertAction: AlertActionType> {
    case prepare
    case selectAction(AlertAction)
  }

  public typealias Mutation = _Mutation<AlertAction>
  public enum _Mutation<AlertAction: AlertActionType> {
    case setTitle(String?)
    case setMessage(String?)
    case setActions([AlertAction])
  }

  public typealias State = _State<AlertAction>
  public struct _State<AlertAction: AlertActionType> {
    public var title: String?
    public var message: String?
    public var actions: [AlertAction]
  }

  public let initialState: State

  public init(title: String? = nil, message: String? = nil, actions: [AlertAction]? = nil) {
    self.initialState = State(title: title, message: message, actions: actions ?? [])
  }

  open func transform(action: Observable<Action>) -> Observable<Action> {
    return action
  }

  open func mutate(action: Action) -> Observable<Mutation> {
    // override point
    return .empty()
  }

  open func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return mutation
  }

  open func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case let .setTitle(title):
      state.title = title
      return state

    case let .setMessage(message):
      state.message = message
      return state

    case let .setActions(actions):
      state.actions = actions
      return state
    }
  }

  open func transform(state: Observable<State>) -> Observable<State> {
    return state
  }
}
#endif
