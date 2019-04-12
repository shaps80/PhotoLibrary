import UIKit

public typealias ImageRequestId = UInt32
public let InvalidImageRequestId: ImageRequestId = 0

public final class ImageManager {

    public enum CachingImageResult {
        case success(ImageFetchResponse)
        case failure(Error)
        case cancelled(ImageRequestId)
    }

    public static let `default` = ImageManager()

    @discardableResult
    public func requestImage(for asset: Asset, targetSize: CGSize, contentMode: ImageAsset.ContentMode, options: ImageFetchOptions, resultHandler: @escaping (CachingImageResult) -> Void) -> ImageRequestId {
        let id = asset.requestId(targetSize: targetSize, contentMode: contentMode)
        // if we already have an active request for this id, just return the id
        // otherwise, create a new request and assign it to this request
        return id
    }

    @discardableResult
    public func requestImageData(for asset: Asset, options: ImageFetchOptions?, resultHandler: @escaping (CachingImageResult) -> Void) -> ImageRequestId {
        let id = asset.requestId(targetSize: nil, contentMode: nil)
        // if we already have an active request for this id, just return the id
        // otherwise, create a new request and assign it to this request
        return id
    }

    public func cancelImageRequest(_ requestId: ImageRequestId) {

    }

    public func startCachingImages(for assets: [Asset], targetSize: CGSize, contentMode: ImageAsset.ContentMode, options: ImageFetchOptions) {

    }

    public func stopCachingImages(for assets: [Asset], targetSize: CGSize, contentMode: ImageAsset.ContentMode, options: ImageFetchOptions) {

    }

    public func stopCachingImagesForAllAssets() {

    }

}

