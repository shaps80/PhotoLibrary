import UIKit
import Composed

internal final class MediaAlbumCell: UICollectionViewCell, ReusableViewNibLoadable {

    @IBOutlet private weak var titleLabel: MediaPrimaryLabel!
    @IBOutlet internal weak var imageView: MediaArtworkImageView!

    internal var assetId: String?

    internal func prepare(title: String?) {
        titleLabel.text = title

        guard accessibilityElements == nil else { return }
        let element = UIAccessibilityElement(accessibilityContainer: self)

        element.isAccessibilityElement = true
        element.accessibilityTraits = .button
        element.accessibilityLabel = titleLabel.text
        element.accessibilityValue = NSLocalizedString("Album", comment: "Voiceover")

        accessibilityElements = [element]
    }

    internal override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        titleLabel.text = nil
        assetId = nil
        accessibilityElements = nil
    }

    private var _accessibilityElements: [Any]?
    override var accessibilityElements: [Any]? {
        set { _accessibilityElements = newValue }
        get {
            let elements = _accessibilityElements
            if let element = elements?.first as? UIAccessibilityElement {
                element.accessibilityFrameInContainerSpace = contentView.bounds
            }

            return elements
        }
    }

}
