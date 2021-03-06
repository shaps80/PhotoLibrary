import UIKit

final class MediaEditingButton: UIButton, Themed {

    override func awakeFromNib() {
        super.awakeFromNib()
        subscribeToThemeUpdates()
    }

    func applyTheme(_ theme: MediaPickerTheme) {
        tintColor = theme.tintColor
    }

}


final class MediaSeparatorView: UIView, Themed {

    override func awakeFromNib() {
        super.awakeFromNib()
        subscribeToThemeUpdates()
    }

    func applyTheme(_ theme: MediaPickerTheme) {
        backgroundColor = theme.separatorColor
    }

}

final class MediaPrimaryLabel: UILabel, Themed {

    override func awakeFromNib() {
        super.awakeFromNib()
        subscribeToThemeUpdates()
    }

    func applyTheme(_ theme: MediaPickerTheme) {
        textColor = theme.primaryTextColor
    }

}

final class MediaSecondaryLabel: UILabel, Themed {

    override func awakeFromNib() {
        super.awakeFromNib()
        subscribeToThemeUpdates()
    }

    func applyTheme(_ theme: MediaPickerTheme) {
        textColor = theme.secondaryTextColor
    }

}

final class MediaDisclosureImageView: UIImageView, Themed {

    override func awakeFromNib() {
        super.awakeFromNib()
        subscribeToThemeUpdates()
    }

    func applyTheme(_ theme: MediaPickerTheme) {
        tintColor = theme.imageTintColor
    }

}

final class MediaArtworkImageView: UIImageView, Themed {

    override func awakeFromNib() {
        super.awakeFromNib()
        subscribeToThemeUpdates()
    }

    func applyTheme(_ theme: MediaPickerTheme) {
        backgroundColor = theme.placeholderBackgroundColor
    }

}

final class MediaCellBackgroundView: UIView, Themed {

    override init(frame: CGRect) {
        super.init(frame: frame)
        subscribeToThemeUpdates()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyTheme(_ theme: MediaPickerTheme) {
        backgroundColor = theme.backgroundColor
    }

}

final class MediaCellSelectionView: UIView, Themed {

    override init(frame: CGRect) {
        super.init(frame: frame)
        subscribeToThemeUpdates()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyTheme(_ theme: MediaPickerTheme) {
        backgroundColor = theme.selectedBackgroundColor
    }

}

final class MediaCollectionView: UICollectionView, Themed {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        subscribeToThemeUpdates()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyTheme(_ theme: MediaPickerTheme) {
        backgroundColor = theme.backgroundColor
        indicatorStyle = theme.scrollIndicatorStyle
    }

}

final class MediaNavigationBar: UINavigationBar, Themed {
    override init(frame: CGRect) {
        super.init(frame: frame)
        subscribeToThemeUpdates()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        subscribeToThemeUpdates()
    }

    func applyTheme(_ theme: MediaPickerTheme) {
        barStyle = theme.navigationBarStyle
        barTintColor = theme.barTintColor
        backgroundColor = theme.barTintColor
        tintColor = theme.tintColor
        isTranslucent = theme.isNavigationTranslucent
        titleTextAttributes = [.foregroundColor: theme.primaryTextColor]
        largeTitleTextAttributes = [.foregroundColor: theme.primaryTextColor]
    }
}

final class MediaNavigationController: UINavigationController, Themed {

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToThemeUpdates()
    }

    func applyTheme(_ theme: MediaPickerTheme) {
        UIView.animate(withDuration: 0.2) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

    override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }

    override var childForHomeIndicatorAutoHidden: UIViewController? {
        return topViewController
    }

    override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        return topViewController
    }

}
