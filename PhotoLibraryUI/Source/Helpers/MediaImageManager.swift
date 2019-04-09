import Photos

internal struct MediaImageObserver: Hashable {
    fileprivate let observer: NSObject
    fileprivate let assetIdentifier: String
}

#warning("Update this to provide a better API and to use NSProgress instances – that way the user could choose to continue in their app and use the images 'later'")
internal final class MediaImageManager {

    internal static let shared = MediaImageManager()
    private let imageManager = PHImageManager.default()

    private var progressHandlers: [String: PHImageRequestID] = [:]
    private var progressObservers: [MediaImageObserver: (CGFloat) -> Void] = [:]

    internal func observeProgress(for observer: NSObject, asset: PHAsset, handler: @escaping (CGFloat) -> Void) {
        guard isRequesting(asset: asset) else { return }
        let observer = MediaImageObserver(observer: observer, assetIdentifier: asset.localIdentifier)
        progressObservers[observer] = handler
    }

    internal func unobserveProgress(for observer: MediaImageObserver) {
        progressObservers[observer] = nil
    }

    internal func isRequesting(asset: PHAsset) -> Bool {
        return progressHandlers[asset.localIdentifier] != nil
    }

    internal func cancelRequest(for asset: PHAsset) {
        guard isRequesting(asset: asset) else { return }
        guard let id = progressHandlers[asset.localIdentifier] else { return }

        progressObservers
            .filter { $0.key.assetIdentifier == asset.localIdentifier }
            .forEach { unobserveProgress(for: $0.key) }

        progressHandlers[asset.localIdentifier] = nil
        imageManager.cancelImageRequest(id)
    }

    internal func request(image asset: PHAsset, result: ((UIImage.Orientation, URL) -> Void)?) {
        guard progressHandlers[asset.localIdentifier] == nil else { return }

        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat

        options.progressHandler = { [weak self, asset] progress, _, _, _ in
            if Thread.isMainThread {
                self?.notifyProgressObservers(assetIdentifier: asset.localIdentifier, progress: CGFloat(progress))
            } else {
                DispatchQueue.main.sync {
                    self?.notifyProgressObservers(assetIdentifier: asset.localIdentifier, progress: CGFloat(progress))
                }
            }
        }

        let request = imageManager.requestImageData(for: asset, options: options) { _, _, orientation, info in
            if let isCancelled = info?["PHImageCancelledKey"] as? Bool, isCancelled { return }

            guard let url = info?["PHImageFileURLKey"] as? URL else {
                fatalError("Either missing data, bad data or missing URL")
            }

            if Thread.isMainThread {
                result?(orientation, url)
            } else {
                DispatchQueue.main.sync {
                    result?(orientation, url)
                }
            }

            guard self.isRequesting(asset: asset) else { return }

            self.progressHandlers[asset.localIdentifier] = nil
            self.progressObservers
                .lazy
                .filter { $0.key.assetIdentifier == asset.localIdentifier }
                .forEach {
                    $0.value(1)
                    self.unobserveProgress(for: $0.key)
            }
        }

        progressHandlers[asset.localIdentifier] = request
    }

    internal func request(preview asset: PHAsset, result: ((Result<AVPlayerItem, Error>) -> Void)?) {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .fastFormat

        imageManager.requestPlayerItem(forVideo: asset, options: options) { item, _ in
            func complete(with item: AVPlayerItem?) {
                if let item = item {
                    result?(.success(item))
                } else {
                    let error = NSError(domain: "com.152percent.Pluto", code: -1, userInfo: [:])
                    result?(.failure(error))
                }
            }

            if Thread.isMainThread {
                complete(with: item)
            } else {
                DispatchQueue.main.sync {
                    complete(with: item)
                }
            }
        }
    }

    internal func request(video asset: PHAsset, result: ((URL) -> Void)?) {
        guard progressHandlers[asset.localIdentifier] == nil else { return }

        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        
        options.progressHandler = { [weak self, asset] progress, _, _, info in
            if Thread.isMainThread {
                self?.notifyProgressObservers(assetIdentifier: asset.localIdentifier, progress: CGFloat(progress))
            } else {
                DispatchQueue.main.sync {
                    self?.notifyProgressObservers(assetIdentifier: asset.localIdentifier, progress: CGFloat(progress))
                }
            }
        }

        let request = imageManager.requestAVAsset(forVideo: asset, options: options) { [unowned self] avAsset, _, info in
            defer {
                if self.isRequesting(asset: asset) {
                    self.progressHandlers[asset.localIdentifier] = nil
                    self.progressObservers
                        .filter { $0.key.assetIdentifier == asset.localIdentifier }
                        .forEach { self.unobserveProgress(for: $0.key) }
                }
            }

            if let isCancelled = info?["PHImageCancelledKey"] as? Bool, isCancelled { return }

            guard let avAsset = avAsset as? AVURLAsset else {
                fatalError("Missing AVAsset")
            }

            if Thread.isMainThread {
                result?(avAsset.url)
            } else {
                DispatchQueue.main.sync {
                    result?(avAsset.url)
                }
            }
        }

        progressHandlers[asset.localIdentifier] = request
    }

    private func notifyProgressObservers(assetIdentifier: String, progress: CGFloat) {
        progressObservers
            .filter { $0.key.assetIdentifier == assetIdentifier }
            .forEach { $0.value(progress)}
    }

}
