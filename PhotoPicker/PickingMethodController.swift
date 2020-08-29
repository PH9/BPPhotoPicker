import AVKit
import UIKit

public protocol PickingMethodControllerDelegate: AnyObject {
  func pickingMethod(_ pickerController: PickingMethodController, wantToPresent controller: UIViewController)
}

open class PickingMethodController: UIAlertController {
  public weak var delegate: PickingMethodControllerDelegate?

  open func addDefaultActions(isSourceTypeAvailable: (_ sourceType: UIImagePickerController.SourceType)
    -> Bool = UIImagePickerController.isSourceTypeAvailable)
  {
    if isSourceTypeAvailable(.camera) {
      let action = UIAlertAction(title: "ใช้กล้องถ่ายรูป", style: .default, handler: askForCameraPermission(_:))
      addAction(action)
    }

    if isSourceTypeAvailable(.photoLibrary) {
      let action = UIAlertAction(title: "เลือกรูปจากอัลบั้ม", style: .default, handler: openPhotoLibrary(_:))
      addAction(action)
    }

    let cancelAction = UIAlertAction(title: "ยกเลิก", style: .cancel, handler: nil)
    addAction(cancelAction)
  }

  private func askForCameraPermission(_: UIAlertAction) {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      openCamera()
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { granted in
        if granted {
          self.openCamera()
        } else {
          self.askingForPermissionGrant()
        }
      }
    case .denied:
      askingForPermissionGrant()
    case .restricted:
      showRestrictedDialog()
    @unknown default:
      showApplicationDoesNotSupportDialog()
    }
  }

  open func openCamera() {
    let controller = createCameraController()
    delegate?.pickingMethod(self, wantToPresent: controller)
  }

  open func openPhotoLibrary(_: UIAlertAction) {
    let controller = createPhotoLibraryPicker()
    delegate?.pickingMethod(self, wantToPresent: controller)
  }

  open func askingForPermissionGrant() {
    let controller = createAskingForPermissionViewController()
    DispatchQueue.main.async {
      self.delegate?.pickingMethod(self, wantToPresent: controller)
    }
  }

  open func showRestrictedDialog() {
    let controller = createCameraRestrictAlertController()
    delegate?.pickingMethod(self, wantToPresent: controller)
  }

  open func showApplicationDoesNotSupportDialog() {
    let controller = createApplicationDoesNotSupport()
    delegate?.pickingMethod(self, wantToPresent: controller)
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

// MARK: - Factory

extension PickingMethodController {
  open func getDefaultMessage() -> String {
    PickingMethodController.getDefaultMessage()
  }

  public static func getDefaultMessage() -> String {
    var string = "คุณสามารถ"
    var separator = ""
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      string += "ถ่ายรูปใหม่ หรือ "
      separator = "\n"
    }

    return string + "เลือกรูป\(separator)ที่มีอยู่แล้วจากอัลบั้มรูป"
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

  open func createCameraController() -> UIImagePickerController {
    let controller = UIImagePickerController()
    controller.allowsEditing = true
    controller.sourceType = .camera
    return controller
  }

  open func createPhotoLibraryPicker() -> UIImagePickerController {
    let controller = UIImagePickerController()
    controller.allowsEditing = true
    controller.sourceType = .photoLibrary
    return controller
  }

  open func createCameraRestrictAlertController() -> UIAlertController {
    let controller = UIAlertController(
      title: "กรุณาติดต่อผู้ปกครองของท่าน",
      message: "ให้อณุญาตใช้งานกล้องถ่ายภาพ",
      preferredStyle: .alert
    )
    let cancelAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
    controller.addAction(cancelAction)
    return controller
  }

  open func createApplicationDoesNotSupport() -> UIAlertController {
    let controller = UIAlertController(
      title: "แอปพลิเคชันยังไม่รอบรับรายการดังกล่าว",
      message: "โปรดลองอัพเดทแอปพลิเคชัน",
      preferredStyle: .alert
    )
    let cancelAction = UIAlertAction(title: "ตกลง", style: .default, handler: nil)
    controller.addAction(cancelAction)
    return controller
  }
}
