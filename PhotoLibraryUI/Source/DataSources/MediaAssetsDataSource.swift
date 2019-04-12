import UIKit
import Photos
import Composed

internal final class MediaAssetsDataSource: PhotosDataSource<PHAsset> {

    private(set) var isEditing: Bool = false
    weak var selectionDelegate: MediaPickerSelectionDelegate?
    
    private var cellConfiguration: DataSourceUIConfiguration?
    internal var imageCache: PHCachingImageManager

    let title: String?
    let summary: String?

    init(imageCache: PHCachingImageManager, assets: PHFetchResult<PHAsset>, title: String? = nil, summary: String? = nil) {
        self.title = title
        self.summary = summary
        self.imageCache = imageCache
        super.init(store: PhotosDataStore(result: assets))
    }

}

extension MediaAssetsDataSource: CollectionUIProvidingDataSource, AssetCellDelegate {

    func sizingStrategy(in collectionView: UICollectionView) -> CollectionUISizingStrategy {
        let traitCollection = collectionView.traitCollection

        var multiplier: CGFloat = 1
        if traitCollection.preferredContentSizeCategory > .extraExtraExtraLarge {
            multiplier = 0.5
        }

        let isPortrait = UIScreen.main.bounds.width < UIScreen.main.bounds.height

        let preferredWidth: CGFloat = traitCollection.userInterfaceIdiom == .pad
            ? traitCollection.horizontalSizeClass == .regular ? 200 : 150
            : isPortrait ? 150 : 200

        let columnCount = Int(floor(collectionView.bounds.width / preferredWidth * multiplier))
        return ColumnSizingStrategy(columnCount: columnCount, sizingMode: .automatic(isUniform: traitCollection.horizontalSizeClass == .compact))
    }

    func headerConfiguration(for section: Int) -> DataSourceUIConfiguration? {
        return title.map { title in
            DataSourceUIConfiguration(prototype: MediaHeaderView.fromNib, dequeueSource: .nib) { view, _, _ in
                view.prepare(title: title, detail: self.summary, isSeparatorHidden: true)
            }
        }
    }

    func willPrepareForReuse(cell: MediaAssetCell, asset: PHAsset, maximumSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions) {
        imageCache.stopCachingImages(for: [asset], targetSize: maximumSize, contentMode: contentMode, options: options)
    }

    func cellConfiguration(for indexPath: IndexPath) -> DataSourceUIConfiguration {
        if let config = cellConfiguration { return config }

        let config = DataSourceUIConfiguration(prototype: MediaAssetCell.fromNib, dequeueSource: .nib) { [unowned self] cell, indexPath, context in
            guard context == .presentation else { return }
            let asset = self.element(at: indexPath)

//            if self.selectionDelegate?.dataSource(self, shouldSelect: asset) == false {
//                cell.contentView.alpha = 0.3
//            }

            cell.prepare(asset: asset)
            cell.delegate = self

            self.prepareCell(cell, asset: asset)

            self.imageCache.requestImage(for: asset, targetSize: cell.maximumSize, contentMode: .aspectFill, options: cell.imageOptions) { [weak self] image, _ in
                guard let self = self else { return }

                if cell.asset?.localIdentifier == asset.localIdentifier {
                    self.dispatchIfNeeded {
                        cell.imageView.image = image
                    }
                }
            }
        }

        cellConfiguration = config
        return config
    }

    func metrics(for section: Int) -> CollectionUISectionMetrics {
        let ratio: CGFloat = collectionView?.traitCollection.horizontalSizeClass == .regular ? 2 : 1
        return CollectionUISectionMetrics(insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), horizontalSpacing: 10 * ratio, verticalSpacing: 5 * ratio)
    }

    private func prepareCell(_ cell: MediaAssetCell, asset: PHAsset) {
        guard MediaImageManager.shared.isRequesting(asset: asset) else {
            cell.setState(.normal)
            return
        }

        cell.setState(.preparing)

        MediaImageManager.shared.observeProgress(for: cell, asset: asset) { [weak self] progress in
            if cell.asset?.localIdentifier == asset.localIdentifier {
                self?.dispatchIfNeeded {
                    cell.setState(.downloading(progress))
                }
            }
        }
    }

}

extension MediaAssetsDataSource: EditHandlingDataSource {

    func supportsEditing(for indexPath: IndexPath) -> Bool {
        return true
    }

    func setEditing(_ editing: Bool, animated: Bool) {
        isEditing = editing
    }

}

extension MediaAssetsDataSource: SelectionHandlingDataSource {

    var allowsMultipleSelection: Bool {
        return isEditing
    }

    fileprivate func dispatchIfNeeded(_ closure: () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.sync {
                closure()
            }
        }
    }

    func shouldSelectElement(at indexPath: IndexPath) -> Bool {
        return true
    }

    func selectElement(at indexPath: IndexPath) {
        selectionDelegate?.dataSource(self, didUpdateSelection: element(at: indexPath))
        
        guard !isEditing else { return }
        let asset = element(at: indexPath)

        guard let global = updateDelegate?.dataSource(self, globalFor: indexPath) else { return }
        guard let cell = collectionView?.cellForItem(at: global.globalIndexPath) as? MediaAssetCell else { return }

        if MediaImageManager.shared.isRequesting(asset: asset) {
            MediaImageManager.shared.cancelRequest(for: asset)
            cell.setState(.normal)
            return
        }

        cell.setState(.preparing)
        prepareCell(cell, asset: asset)
    }

    func deselectElement(at indexPath: IndexPath) {
        selectionDelegate?.dataSource(self, didUpdateSelection: element(at: indexPath))
    }

}

extension MediaAssetsDataSource: GlobalViewsProvidingDataSource {

    var placeholderView: UIView? {
        #warning("Update this to return a PlaceholderView with 2 labels in a stackView – use a XIB")
        return nil
//        let title = NSLocalizedString("No Videos", comment: "Placeholder title")
//        let detail = NSLocalizedString("This album contains no video.", comment: "Placeholder message")
//        return PlaceholderLabel(title: title, detail: detail)
    }

}
