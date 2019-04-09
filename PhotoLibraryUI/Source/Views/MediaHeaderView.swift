import UIKit
import Composed

final class MediaHeaderView: DataSourceHeaderFooterView, ReusableViewNibLoadable, Themed {

    @IBOutlet private weak var titleLabel: MediaPrimaryLabel!
    @IBOutlet private weak var detailLabel: MediaSecondaryLabel!
    @IBOutlet private weak var separatorView: MediaSeparatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        subscribeToThemeUpdates()
    }

    func prepare(title: String, detail: String?, isSeparatorHidden: Bool = false) {
        titleLabel.text = title
        detailLabel.text = detail
        detailLabel.isHidden = detail == nil
        separatorView.isHidden = isSeparatorHidden
        configureAccessiblity()
    }

    private var _accessibilityElements: [Any]?
    override var accessibilityElements: [Any]? {
        set { _accessibilityElements = newValue }
        get {
            let elements = _accessibilityElements
            (elements?.first as? UIAccessibilityElement)?
                .accessibilityFrameInContainerSpace = titleLabel.frame.union(detailLabel.frame)
            return elements
        }
    }

    private func configureAccessiblity() {
        guard accessibilityElements == nil else { return }

        let element = UIAccessibilityElement(accessibilityContainer: self)
        element.isAccessibilityElement = true
        element.accessibilityTraits = .header
        element.accessibilityLabel = titleLabel.text
        element.accessibilityHint = detailLabel.text
        accessibilityElements = [element]
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        detailLabel.text = nil
        accessibilityElements = nil
    }

    func applyTheme(_ theme: MediaPickerTheme) {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        detailLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        backgroundColor = theme.backgroundColor
    }

}
