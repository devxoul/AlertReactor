#if os(iOS) || os(tvOS)
import XCTest
import RxExpect
import RxTest
import AlertReactor

class AlertReactorTests: XCTestCase {
  func testReactor() {
    let test = RxExpect()
    let reactor = MyAlertReactor(scheduler: test.scheduler)
    test.retain(reactor)
    test.input(reactor.action, [next(100, .prepare)])
    test.assert(reactor.state.map { $0.actions }) { events in
      XCTAssertEqual(events.elements.count, 5)
      XCTAssertEqual(events.elements[0], [])
      XCTAssertEqual(events.elements[1], [.cancel])
      XCTAssertEqual(events.elements[2], [.edit, .cancel])
      XCTAssertEqual(events.elements[3], [.edit, .delete, .cancel])
      XCTAssertEqual(events.elements[4], [.edit, .share, .delete, .cancel])
    }
  }
}
#endif
