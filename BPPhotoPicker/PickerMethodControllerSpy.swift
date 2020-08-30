@testable import BPPhotoPicker
import UIKit

class PickingMethodControllerSpyDelegate: PickingMethodControllerDelegate {
  private(set) var pickerMethodWantToPresentCalledCount = 0
  private(set) var latestPickingController: PickingMethodController?
  private(set) var latestWantToPresentController: UIViewController?
  func pickingMethod(_ pickerController: PickingMethodController, wantToPresent controller: UIViewController) {
    pickerMethodWantToPresentCalledCount += 1
    latestPickingController = pickerController
    latestWantToPresentController = controller
  }
}

class PickerMethodControllerSpy: PickingMethodController {
  private(set) var askForCameraPermissionCalledCount = 0
  override func askForCameraPermission(_ action: UIAlertAction) {
    super.askForCameraPermission(action)
    askForCameraPermissionCalledCount += 1
  }

  private(set) var openPhotoLibraryCalledCount = 0
  override func openPhotoLibrary(_ action: UIAlertAction) {
    super.openPhotoLibrary(action)
    openPhotoLibraryCalledCount += 1
  }

  typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
  func tapButton(atIndex index: Int) {
    guard let block = actions[index].value(forKey: "handler") else { return }
    let handler = unsafeBitCast(block as AnyObject, to: AlertHandler.self)
    handler(actions[index])
  }
}
