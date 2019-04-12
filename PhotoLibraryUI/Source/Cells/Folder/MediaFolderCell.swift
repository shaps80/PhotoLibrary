import UIKit
import Composed

internal final class MediaFolderCell: UICollectionViewCell, ReusableViewNibLoadable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet internal var imageViews: [MediaArtworkImageView]!

    internal var assetIds: [String] = []
    private(set) var isEditing: Bool = false

    internal func prepare(title: String?) {
        titleLabel.text = title

        guard accessibilityElements == nil else { return }
        let element = UIAccessibilityElement(accessibilityContainer: self)

        element.isAccessibilityElement = true
        element.accessibilityTraits = .button
        element.accessibilityLabel = titleLabel.text
        element.accessibilityValue = NSLocalizedString("Folder", comment: "Voiceover")

        accessibilityElements = [element]
    }

    internal override func prepareForReuse() {
        super.prepareForReuse()

        imageViews.forEach { $0.image = nil }
        titleLabel.text = nil
        assetIds.removeAll()
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

extension MediaFolderCell: DataSourceEditableView {

    func setEditing(_ editing: Bool, animated: Bool) {
        isEditing = editing

        if animated {
            UIView.animate(withDuration: 0.2) {
                self.contentView.alpha = editing ? 0.3 : 1
            }
        } else {
            contentView.alpha = editing ? 0.3 : 1
        }
    }

}
