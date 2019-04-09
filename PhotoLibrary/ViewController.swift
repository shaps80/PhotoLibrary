import UIKit
import PhotosUI
import PhotoLibraryUI

final class ViewController: UIViewController, MediaPickerDelegate {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let controller = MediaPickerViewController(in: .copy)
        controller.allowsPickingMultipleItems = true
        controller.interfaceStyle = .dark
        present(controller, animated: true, completion: nil)
    }

    func mediaPicker(_ controller: MediaPickerViewController, didPickMedia media: [PHAsset]) {
        print("Picked: \(media)")
    }

    func mediaPickerWasCancelled(_ controller: MediaPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

}
