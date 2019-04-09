import UIKit
import Photos
import Composed

internal final class MediaContentViewController: DataSourceViewController {

    override class var collectionViewClass: UICollectionView.Type {
        return MediaCollectionView.self
    }

    public var allowsPickingMultipleItems: Bool = false

    private let allowedMediaTypes: [PHAssetMediaType]
    private let allowedMediaSubtypes: [PHAssetMediaSubtype]
    private let mode: MediaPickerViewController.ImportMode
    private let cachingManager: PHCachingImageManager

    required init(allowedMediaTypes: [PHAssetMediaType], allowedMediaSubtypes: [PHAssetMediaSubtype], mode: MediaPickerViewController.ImportMode, cachingManager: PHCachingImageManager? = nil) {
        self.allowedMediaTypes = allowedMediaTypes
        self.allowedMediaSubtypes = allowedMediaSubtypes
        self.mode = mode
        self.cachingManager = cachingManager ?? PHCachingImageManager()

        let dataSource = ComposedDataSource()

        super.init(dataSource: dataSource)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInsetAdjustmentBehavior = .always
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearSelection()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return MediaThemeProvider.shared.currentTheme.statusBarStyle
    }

    private func invalidateEditingState(animated: Bool) {
        collectionView.allowsMultipleSelection = isEditing
        collectionView.indexPathsForSelectedItems?.forEach { collectionView.deselectItem(at: $0, animated: animated) }

        var leftItems: [UIBarButtonItem] = []
        var rightItems: [UIBarButtonItem] = []

        if isEditing {

        } else {
            if presentingViewController != nil {
                rightItems.append(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel)))
            }

            rightItems.append(UIBarButtonItem(title: NSLocalizedString("Select", comment: "Begin editing with multiple selection support"), style: .plain, target: self, action: #selector(beginEditing)))
        }

        navigationItem.rightBarButtonItems = rightItems
        navigationItem.leftBarButtonItems = leftItems
    }
    
}

extension MediaContentViewController {

    weak var picker: MediaPickerViewController? {
        return (navigationController as? MediaNavigationController)?
            .parent as? MediaPickerViewController
    }

}

private extension MediaContentViewController {

    @objc func beginEditing() {
        setEditing(true, animated: true)
    }

    @objc func endEditing() {
        setEditing(false, animated: true)
    }

    @objc func cancel() {
        guard let picker = picker else { return }
        picker.delegate?.mediaPickerWasCancelled?(picker)
    }

}
