import Composed
import UIKit

internal final class MediaSmartAlbumCell: UICollectionViewCell, ReusableViewNibLoadable, Themed {

    @IBOutlet weak var titleLabel: MediaPrimaryLabel!
    @IBOutlet weak var separatorView: MediaSeparatorView!
    @IBOutlet weak var disclosureView: UIImageView!

    private(set) var isEditing: Bool = false

    internal override func awakeFromNib() {
        super.awakeFromNib()

        backgroundView = MediaCellBackgroundView()
        selectedBackgroundView = MediaCellSelectionView()

        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.adjustsFontForContentSizeCategory = true

        subscribeToThemeUpdates()
    }

    func applyTheme(_ theme: MediaPickerTheme) {
        disclosureView.tintColor = theme.imageTintColor
    }

    internal func prepare(title: String?) {
        titleLabel.text = title

        guard accessibilityElements == nil else { return }
        let element = UIAccessibilityElement(accessibilityContainer: self)

        element.isAccessibilityElement = true
        element.accessibilityTraits = .button
        element.accessibilityLabel = titleLabel.text
        element.accessibilityValue = NSLocalizedString("Smart Album", comment: "Voiceover")

        accessibilityElements = [element]
    }

    internal override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
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

extension MediaSmartAlbumCell: DataSourceEditableView {

    func setEditing(_ editing: Bool, animated: Bool) {
        isEditing = editing
        selectedBackgroundView = editing ? nil : MediaCellSelectionView()

        if animated {
            UIView.animate(withDuration: 0.24) {
                self.contentView.alpha = editing ? 0.3 : 1
            }
        } else {
            contentView.alpha = editing ? 0.3 : 1
        }
    }

}
