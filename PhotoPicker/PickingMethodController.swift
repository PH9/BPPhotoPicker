import AVKit
import UIKit

public protocol PickingMethodControllerDelegate: AnyObject {
  func pickingMethod(_ controller: PickingMethodController)
  func pickingMethod(_ controller: PickingMethodController, wantToPresent controller: UIViewController)
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
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      openCamera()
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { granted in
        if granted {
          self.openCamera()
        } else {
          // TODO:
        }
      }
    case .denied:
      askingForPermissionGrant()
      return
    case .restricted:
      // TODO: Show dialog to ask permission from
      return
    @unknown default:
      // TODO: Show dialog that app doesn't support
      return
    }
  }

  private func openCamera() {
    let controller = PickingMethodController.createCameraController()
    delegate?.pickingMethod(self, wantToPresent: controller)
  }

  private func openPhotoLibrary(_: UIAlertAction) {
    let controller = PickingMethodController.createPhotoLibraryPicker()
    delegate?.pickingMethod(self, wantToPresent: controller)
  }

  open func askingForPermissionGrant() {
    let controller = createAskingForPermissionViewController()
    delegate?.pickingMethod(self, wantToPresent: controller)
  }

  open func createAskingForPermissionViewController() -> UIAlertController {
    let controller = UIAlertController(
      title: "กรุณาให้สิทธิ์ใช้งานกล้องถ่ายภาพ",
      message: "เพื่อใช้ในการถ่ายภาพ",
      preferredStyle: .alert
    )
    let gotoApplicationSettingAction = UIAlertAction(
      title: "ดำเนินการต่อ",
      style: .default,
      handler: gotoApplicationSetting(_:)
    )
    controller.addAction(gotoApplicationSettingAction)
    let cancelAction = UIAlertAction(title: "ยกเลิก", style: .cancel, handler: nil)
    controller.addAction(cancelAction)
    return controller
  }

  open func gotoApplicationSetting(_: Any) {
    guard let applicationSettingURL = URL(string: UIApplication.openSettingsURLString) else {
      return
    }

    guard UIApplication.shared.canOpenURL(applicationSettingURL) else {
      return
    }

    UIApplication.shared.open(applicationSettingURL)
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

  public static func createCameraController() -> UIImagePickerController {
    let controller = UIImagePickerController()
    controller.allowsEditing = true
    controller.sourceType = .camera
    return controller
  }

  public static func createPhotoLibraryPicker() -> UIImagePickerController {
    let controller = UIImagePickerController()
    controller.allowsEditing = true
    controller.sourceType = .photoLibrary
    return controller
  }
}
