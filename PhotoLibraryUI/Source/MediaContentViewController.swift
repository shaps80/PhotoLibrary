import UIKit
import Photos
import Composed

internal final class MediaContentViewController: DataSourceViewController {

    override class var collectionViewClass: UICollectionView.Type {
        return MediaCollectionView.self
    }

    public var allowsPickingMultipleItems: Bool {
        return picker?.allowsPickingMultipleItems ?? false
    }

    private let mode: MediaPickerViewController.ImportMode
    private let imageCache: PHCachingImageManager
    private let assetOptions: PHFetchOptions?

    required init(assetOptions: PHFetchOptions? = nil, mode: MediaPickerViewController.ImportMode, imageCache: PHCachingImageManager) {
        self.assetOptions = assetOptions
        self.mode = mode
        self.imageCache = imageCache

        //swiftlint:disable force_cast
        let options = assetOptions ?? PHFetchOptions()
        options.fetchLimit = 10

        let recents = PHAsset.fetchAssets(with: options)
        let userAlbums = PHCollectionList.fetchTopLevelUserCollections(with: assetOptions)
        let shared = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumCloudShared, options: assetOptions) as! PHFetchResult<PHCollection>

        let albums: [DataSource] = [
            MediaAlbumsDataSource(layoutStyle: .columns, store: PhotosDataStore(result: userAlbums), assetOptions: assetOptions, imageCache: imageCache),
            MediaAlbumsDataSource(layoutStyle: .columns, store: PhotosDataStore(result: shared), assetOptions: assetOptions, imageCache: imageCache),
            MediaAssetsDataSource(imageCache: imageCache, assets: recents,
                                  title: NSLocalizedString("Recently Added", comment: "Header title"),
                                  summary: NSLocalizedString("Media added to your library recently.", comment: "Header message")),
        ]

        let dataSource = ComposedDataSource(children: albums)
        super.init(dataSource: dataSource)

        self.imageCache.allowsCachingHighQualityImages = false
        assetOptions?.wantsIncrementalChangeDetails = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.contentInsetAdjustmentBehavior = .always
        invalidateBarButtonItems(animated: false)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearSelection()
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        invalidateBarButtonItems(animated: false)
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        invalidateBarButtonItems(animated: animated)
    }

    private func invalidateBarButtonItems(animated: Bool) {
        collectionView.allowsMultipleSelection = isEditing

        if !isEditing {
            collectionView.indexPathsForSelectedItems?.forEach { collectionView.deselectItem(at: $0, animated: animated) }
        }

        var leftItems: [UIBarButtonItem] = []
        var rightItems: [UIBarButtonItem] = []

        if isEditing {
            let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endEditing))
            let pickItem = UIBarButtonItem(title: mode.title, style: .plain, target: self, action: #selector(pickAssets))
            rightItems.append(contentsOf: [doneItem, pickItem])

            if collectionView.indexPathsForSelectedItems?.isEmpty == true {
                leftItems.append(UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(fillSelection)))
                pickItem.isEnabled = false
            } else {
                leftItems.append(UIBarButtonItem(title: "Select None", style: .plain, target: self, action: #selector(emptySelection)))
                pickItem.isEnabled = true
            }
        } else {
            if presentingViewController != nil {
                rightItems.append(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel)))
            }

            if allowsPickingMultipleItems {
                let title = NSLocalizedString("Select", comment: "Begin editing with multiple selection support")
                rightItems.append(UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(beginEditing)))
            }
        }

        navigationItem.rightBarButtonItems = rightItems
        navigationItem.leftBarButtonItems = leftItems
    }

    private var isFirstLayout: Bool = true
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard dataSource is MediaAssetsDataSource, isFirstLayout else { return }

        let contentHeight = layout.collectionViewContentSize.height
            + view.safeAreaInsets.bottom

        if contentHeight > collectionView.bounds.height {
            let contentOffset = CGPoint(x: 0, y: contentHeight - collectionView.bounds.height)
            collectionView.setContentOffset(contentOffset, animated: false)
        }

        isFirstLayout = false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return MediaThemeProvider.shared.currentTheme.statusBarStyle
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

    @objc private func fillSelection() {
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            }
        }

        invalidateBarButtonItems(animated: false)
    }

    @objc private func emptySelection() {
        collectionView.indexPathsForSelectedItems?.forEach {
            collectionView.deselectItem(at: $0, animated: false)
        }

        invalidateBarButtonItems(animated: false)
    }

    @objc func pickAssets() {
        guard let picker = picker else { return }
        #warning("Need to include assets")
        picker.delegate?.mediaPicker?(picker, didPickMedia: [])
    }

    @objc func cancel() {
        guard let picker = picker else { return }
        picker.delegate?.mediaPickerWasCancelled?(picker)
    }

}
