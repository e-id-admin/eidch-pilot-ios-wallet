import Factory
import Foundation
import XCTest
@testable import BITInvitation

final class CameraPermissionViewModelTests: XCTestCase {

  func testWithInitialData() async {
    var isCompleted = false
    let viewModel = await CameraPermissionViewModel(initialState: .notDetermined) { isCompleted = true }

    let state = await viewModel.state
    let stateError = await viewModel.stateError

    XCTAssertEqual(state, .notDetermined)
    XCTAssertNil(stateError)
    XCTAssertFalse(isCompleted)
  }

  func testHappyPath() async {
    var isCompleted = false
    let viewModel = await CameraPermissionViewModel(initialState: .notDetermined) { isCompleted = true }

    await viewModel.send(event: .allowCamera)

    let state = await viewModel.state
    let stateError = await viewModel.stateError

    XCTAssertEqual(state, .authorized)
    XCTAssertNil(stateError)
    XCTAssertTrue(isCompleted)
  }

  func testInitShortcut() async {
    var isCompleted = false
    let viewModel = await CameraPermissionViewModel(initialState: .authorized) { isCompleted = true }

    let state = await viewModel.state
    let stateError = await viewModel.stateError

    XCTAssertEqual(state, .authorized)
    XCTAssertNil(stateError)
    XCTAssertTrue(isCompleted)
  }

}
