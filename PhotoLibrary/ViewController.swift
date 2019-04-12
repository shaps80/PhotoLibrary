import UIKit
import Photos
import MediaLibraryUI

final class ViewController: UIViewController, MediaPickerDelegate {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let controller = MediaPickerViewController(in: .copy)
        controller.delegate = self
        controller.allowsPickingMultipleItems = true
        present(controller, animated: true, completion: nil)
    }

    func mediaPicker(_ controller: MediaPickerViewController, didPickMedia media: [PHAsset]) {
        controller.dismiss(animated: true, completion: nil)
    }

    func mediaPickerWasCancelled(_ controller: MediaPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

}
