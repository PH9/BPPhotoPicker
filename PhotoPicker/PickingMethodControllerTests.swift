@testable import PhotoPicker
import XCTest

class PickerMethodControllerTests: XCTestCase {
  let sut = PickerMethodControllerSpy(title: "", message: "", preferredStyle: .actionSheet)

  func testAddDefaultAction_withAllSourceTypeAvailable() {
    var sourceTypeParam: [UIImagePickerController.SourceType] = []
    sut.addDefaultActions(isSourceTypeAvailable: { sourceType in
      sourceTypeParam.append(sourceType)
      return true
    })

    XCTAssertEqual(sourceTypeParam.count, 2)
    XCTAssertEqual(sourceTypeParam[0], .camera)
    XCTAssertEqual(sourceTypeParam[1], .photoLibrary)

    XCTAssertEqual(sut.actions.count, 3)
    XCTAssertEqual("ใช้กล้องถ่ายรูป", sut.actions[0].title)
    XCTAssertEqual(sut.actions[0].style, .default)
    XCTAssertEqual("เลือกรูปจากอัลบั้ม", sut.actions[1].title)
    XCTAssertEqual(sut.actions[1].style, .default)
    XCTAssertEqual("ยกเลิก", sut.actions[2].title)
    XCTAssertEqual(sut.actions[2].style, .cancel)
  }

  func testAddDefaultAction_withNonSourceTypeAvailable() {
    sut.addDefaultActions(isSourceTypeAvailable: { _ in false })

    XCTAssertEqual(sut.actions.count, 1)
    XCTAssertEqual("ยกเลิก", sut.actions[0].title)
    XCTAssertEqual(sut.actions[0].style, .cancel)
  }

  func testTapButtons() {
    let spy = PickingMethodControllerSpyDelegate()
    sut.delegate = spy
    sut.addDefaultActions(isSourceTypeAvailable: { _ in true })

    sut.tapButton(atIndex: 0)
    XCTAssertEqual(sut.askForCameraPermissionCalledCount, 1)

    sut.tapButton(atIndex: 1)

    XCTAssertEqual(sut.openPhotoLibraryCalledCount, 1)
    XCTAssertEqual(spy.pickerMethodWantToPresentCalledCount, 1)
    XCTAssertEqual(spy.latestPickingController, sut)
    XCTAssert(spy.latestWantToPresentController is UIImagePickerController)
  }
}
