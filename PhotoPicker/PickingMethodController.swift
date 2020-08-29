import UIKit

public protocol PickingMethodControllerDelegate: AnyObject {
  func pickingMethod(_ controller: PickingMethodController)
  func pickingMethod(_ controller: PickingMethodController, wantToPresent vc: UIImagePickerController)
}

open class PickingMethodController: UIAlertController {
  public weak var delegate: PickingMethodControllerDelegate?

  open func addDefaultActions() {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let action = UIAlertAction(title: "ใช้กล้องถ่ายรูป", style: .default, handler: openCamera(_:))
      addAction(action)
    }

    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      let action = UIAlertAction(title: "เลือกรูปจากอัลบั้ม", style: .default, handler: openPhotoLibrary(_:))
      addAction(action)
    }

    let cancelAction = UIAlertAction(title: "ยกเลิก", style: .cancel, handler: nil)
    addAction(cancelAction)
  }

  private func openCamera(_: UIAlertAction) {
    let vc = UIImagePickerController()
    vc.allowsEditing = true
    vc.sourceType = .camera
    delegate?.pickingMethod(self, wantToPresent: vc)
  }

  private func openPhotoLibrary(_: UIAlertAction) {
    let vc = PickingMethodController.createPhotoLibraryPicker()
    delegate?.pickingMethod(self, wantToPresent: vc)
  }
}

extension PickingMethodController {
  public static func getDefaultMessage() -> String {
    var string = "คุณสามารถ"
    var separator = ""
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      string += "ถ่ายรูปใหม่ หรือ "
      separator = "\n"
    }

    return string + "เลือกรูป\(separator)ที่มีอยู่แล้วจากอัลบั้มรูป"
  }

  public static func createPhotoLibraryPicker() -> UIImagePickerController {
    let vc = UIImagePickerController()
    vc.allowsEditing = true
    vc.sourceType = .photoLibrary
    return vc
  }
}
