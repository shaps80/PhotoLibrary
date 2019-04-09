import UIKit
import Photos
import Composed

internal final class MediaAlbumsDataSource: PhotosDataSource<PHCollection> {

    private(set) var isEditing: Bool = false

    internal enum LayoutStyle {
        case columns
        case table
    }

    private let layoutStyle: LayoutStyle
    private let imageCache: PHCachingImageManager
    private let assetOptions: PHFetchOptions?

    internal init(layoutStyle: LayoutStyle, store: PhotosDataStore<PHCollection>, assetOptions: PHFetchOptions?, imageCache: PHCachingImageManager) {
        self.layoutStyle = layoutStyle
        self.imageCache = imageCache
        self.assetOptions = assetOptions
        super.init(store: store)
    }

}

extension MediaAlbumsDataSource: EditHandlingDataSource {

    func supportsEditing(for indexPath: IndexPath) -> Bool {
        return true
    }

    func setEditing(_ editing: Bool, animated: Bool) {
        isEditing = editing
    }

}

extension MediaAlbumsDataSource: CollectionUIProvidingDataSource {

    internal func cellConfiguration(for indexPath: IndexPath) -> DataSourceUIConfiguration {
        let collection = element(at: indexPath)

        if let collection = collection as? PHAssetCollection {
            let options = assetOptions ?? PHFetchOptions()
            options.fetchLimit = 1
            let assets = PHAsset.fetchAssets(in: collection, options: assetOptions)

            if collection.assetCollectionType == .smartAlbum {
                return DataSourceUIConfiguration(prototype: MediaSmartAlbumCell.fromNib, dequeueSource: .nib) { cell, _, _ in
                    let collection = collection
                    cell.prepare(title: collection.localizedTitle)
                }
            } else {
                return DataSourceUIConfiguration(prototype: MediaAlbumCell.fromNib, dequeueSource: .nib) { [weak self] cell, _, context in
                    guard let self = self else { return }
                    let collection = collection

                    guard let asset = assets.firstObject else { return }
                    cell.assetId = asset.localIdentifier

                    cell.prepare(title: collection.localizedTitle)
                    guard context == .presentation, cell.imageView.image == nil else { return }

                    let size = CGSize(width: 400, height: 400)
                    let options = PHImageRequestOptions()
                    options.deliveryMode = .fastFormat

                    self.imageCache.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { image, _ in
                        // The cell may have been recycled by the time this handler gets called;
                        // set the cell's thumbnail image only if it's still showing the same asset.
                        if cell.assetId == asset.localIdentifier {
                            DispatchQueue.main.async {
                                cell.imageView.image = image
                            }
                        }
                    }
                }
            }
        } else {
            guard let list = collection as? PHCollectionList else {
                return DataSourceUIConfiguration(prototype: MediaAlbumCell.fromNib, dequeueSource: .nib) { cell, _, _ in
                    cell.prepare(title: collection.localizedTitle)
                }
            }

            let options = assetOptions ?? PHFetchOptions()
            options.fetchLimit = 4

            let collections = PHAssetCollection.fetchCollections(in: list, options: options)
            var collectionAssets: [PHAsset] = []

            collections.enumerateObjects { [weak self] collection, _, _ in
                guard let self = self else { return }
                guard let collection = collection as? PHAssetCollection else { return }

                let options = self.assetOptions ?? PHFetchOptions()
                options.fetchLimit = 1

                guard let asset = PHAsset.fetchAssets(in: collection, options: options).firstObject else { return }
                collectionAssets.append(asset)
            }

            return DataSourceUIConfiguration(prototype: MediaFolderCell.fromNib, dequeueSource: .nib) { cell, _, context in
                let collection = collection
                cell.prepare(title: collection.localizedTitle)

                guard context == .presentation else { return }

                cell.assetIds = collectionAssets.map { $0.localIdentifier }

                let size = CGSize(width: 400, height: 400)
                for (index, asset) in collectionAssets.enumerated() {
                    self.imageCache.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { [index] image, _ in
                        // The cell may have been recycled by the time this handler gets called;
                        // set the cell's thumbnail image only if it's still showing the same asset.
                        if cell.assetIds.contains(asset.localIdentifier) {
                            cell.imageViews[index].image = image
                        }
                    }
                }
            }
        }
    }

    internal func sizingStrategy(in collectionView: UICollectionView) -> CollectionUISizingStrategy {
        let isPortrait = UIScreen.main.bounds.width < UIScreen.main.bounds.height
        let columnCount = layoutStyle == .columns
            ? collectionView.traitCollection.horizontalSizeClass == .compact
                ? 2
                : isPortrait ? 4 : 6
            : 1
        return ColumnSizingStrategy(columnCount: columnCount, sizingMode: .automatic(isUniform: true))
    }

    internal func metrics(for section: Int) -> CollectionUISectionMetrics {
        let columnCount = layoutStyle == .columns ? 2 : 1
        return CollectionUISectionMetrics(
            insets: columnCount == 2 ? UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) : .zero,
            horizontalSpacing: columnCount == 2 ? 10 : 0,
            verticalSpacing: columnCount == 2 ? 20 : 0
        )
    }

}

extension MediaAlbumsDataSource: GlobalViewsProvidingDataSource {

    var placeholderView: UIView? {
        #warning("Update this to return a PlaceholderView with 2 labels in a stackView – use a XIB")
        return nil
//        let title = NSLocalizedString("No Videos", comment: "Placeholder title")
//        let detail = NSLocalizedString("This folder contains no albums.", comment: "Placeholder message")
//        return PlaceholderLabel(title: title, detail: detail)
    }

}
