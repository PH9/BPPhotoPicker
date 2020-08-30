import BPPhotoPicker
import UIKit

class ViewController: UIViewController {
  @IBOutlet var previewImageView: UIImageView!

  @IBAction func presentActionSheet(_ sender: UIView) {
    presentPickingMethodController(sender)
  }

  @IBAction func autoPickerHandler(_: Any) {}

  @IBAction func gotoApplicationSetting(_: Any) {
    guard let applicationSettingURL = URL(string: UIApplication.openSettingsURLString) else {
      return
    }

    guard UIApplication.shared.canOpenURL(applicationSettingURL) else {
      return
    }

    if #available(iOS 10.0, *) {
      UIApplication.shared.open(applicationSettingURL)
    } else {
      UIApplication.shared.openURL(applicationSettingURL)
    }
  }
}

// MARK: - PickingMethodController

extension ViewController: PickingMethodControllerDelegate {
  private func presentPickingMethodController(_ sender: UIView) {
    let controller = PickingMethodController(
      title: "เปลี่ยนรูปประจำตัว",
      message: PickingMethodController.getDefaultMessage(),
      preferredStyle: .actionSheet
    )
    controller.popoverPresentationController?.sourceView = sender
    controller.addDefaultActions()
    controller.delegate = self
    present(controller, animated: true, completion: nil)
  }

  func pickingMethod(_: PickingMethodController, wantToPresent controller: UIViewController) {
    (controller as? UIImagePickerController)?.delegate = self
    present(controller, animated: true, completion: nil)
  }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    guard let image = info[.editedImage] as? UIImage else {
      return
    }

    previewImageView.image = image
    picker.dismiss(animated: true, completion: nil)
  }
}
