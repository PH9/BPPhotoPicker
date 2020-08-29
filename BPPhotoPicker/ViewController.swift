import PhotoPicker
import UIKit

class ViewController: UIViewController {
  @IBOutlet var previewImageView: UIImageView!

  @IBAction func presentActionSheet(_ sender: UIView) {
    presentPickingMethodController(sender)
  }

  @IBAction func autoPickerHandler(_: Any) {}
}

// MARK: - PickingMethodController

extension ViewController: PickingMethodControllerDelegate {
  private func presentPickingMethodController(_ sender: UIView) {
    let vc = PickingMethodController(
      title: "เปลี่ยนรูปประจำตัว",
      message: PickingMethodController.getDefaultMessage(),
      preferredStyle: .actionSheet
    )
    vc.popoverPresentationController?.sourceView = sender
    vc.addDefaultActions()
    vc.delegate = self
    present(vc, animated: true, completion: nil)
  }

  func pickingMethod(_: PickingMethodController) {}

  func pickingMethod(_: PickingMethodController, wantToPresent vc: UIImagePickerController) {
    vc.delegate = self
    present(vc, animated: true, completion: nil)
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
