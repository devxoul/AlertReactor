import XCTest
import RxExpect
import RxTest
import AlertReactor

class AlertReactorTests: XCTestCase {
  func testReactor() {
    RxExpect { test in
      let reactor = MyAlertReactor(scheduler: test.scheduler)
      test.retain(reactor)
      test.input(reactor.action, [next(100, .prepare)])
      test.assert(reactor.state.map { $0.actions })
        .filterNext()
        .equal([
          [],
          [.cancel],
          [.edit, .cancel],
          [.edit, .delete, .cancel],
          [.edit, .share, .delete, .cancel],
        ])
    }
  }
}
