#if os(iOS) || os(tvOS)
import XCTest
import RxExpect
import RxTest
import AlertReactor

class AlertControllerTests: XCTestCase {
  func testState_title() {
    let reactor = AlertReactor<MyAlertAction>()
    reactor.isStubEnabled = true

    let controller = AlertController<MyAlertAction>(reactor: reactor)
    _ = controller.view
    reactor.stub.state.value.title = "Hello"
    XCTAssertEqual(controller.title, "Hello")
  }

  func testState_message() {
    let reactor = AlertReactor<MyAlertAction>()
    reactor.isStubEnabled = true

    let controller = AlertController<MyAlertAction>(reactor: reactor)
    _ = controller.view
    reactor.stub.state.value.message = "Choose an item"
    XCTAssertEqual(controller.message, "Choose an item")
  }

  func testState_actions() {
    let reactor = AlertReactor<MyAlertAction>()
    reactor.isStubEnabled = true

    let controller = AlertController<MyAlertAction>(reactor: reactor)
    _ = controller.view
    XCTAssertEqual(controller.actions.count, 0)

    reactor.stub.state.value.actions = [.cancel]
    XCTAssertEqual(controller.actions.count, 1)
    XCTAssertEqual(controller.actions[0].title, "Cancel")
    XCTAssertEqual(controller.actions[0].style, .cancel)

    reactor.stub.state.value.actions = [.delete, .cancel]
    XCTAssertEqual(controller.actions.count, 2)
    XCTAssertEqual(controller.actions[0].title, "Delete")
    XCTAssertEqual(controller.actions[0].style, .destructive)
    XCTAssertEqual(controller.actions[1].title, "Cancel")
    XCTAssertEqual(controller.actions[1].style, .cancel)

    reactor.stub.state.value.actions = [.edit, .share, .delete, .cancel]
    XCTAssertEqual(controller.actions.count, 4)
    XCTAssertEqual(controller.actions[0].title, "Edit")
    XCTAssertEqual(controller.actions[0].style, .default)
    XCTAssertEqual(controller.actions[1].title, "Share")
    XCTAssertEqual(controller.actions[1].style, .default)
    XCTAssertEqual(controller.actions[2].title, "Delete")
    XCTAssertEqual(controller.actions[2].style, .destructive)
    XCTAssertEqual(controller.actions[3].title, "Cancel")
    XCTAssertEqual(controller.actions[3].style, .cancel)
  }
}
#endif
