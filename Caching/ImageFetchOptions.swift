import Foundation
import CoreGraphics

/// Options for delivering requested image data, used by the deliveryMode property.
public struct ImageFetchOptions {

    /// Delivery mode. Defaults to .opportunistic
    public var deliveryMode: DeliveryMode = .opportunistic
    /// Resize mode. Does not apply when size is .maximumSize. Defaults to .none
    public var resizeMode: ResizeMode = .none
    /// If necessary will download the image (client can monitor using progressHandler). Defaults to false
    public var isNetworkAccessAllowed: Bool = true
    /// Return only a single result, blocking until available (or failure). Defaults to false
    public var isSynchronous: Bool = false
    /// Provide caller a way to be told how much progress has been made prior to delivering the data when downloading. Defaults to nil
    public var progressHandler: AssetImageProgressHandler?

    public init() { }

}

extension ImageFetchOptions {

    /// Options for how to resize the requested image to fit a target size, used by the resizeMode property.
    public enum ResizeMode {
        /// No resize
        case none
        // Use targetSize as a hint for optimal decoding when the source image is a compressed format (i.e. subsampling), the delivered image may be larger than targetSize
        case fast
        /// Same as above but also guarantees the delivered image is exactly targetSize (must be set when a normalizedCropRect is specified)
        case exact
    }

    /// Options for delivering requested image data, used by the deliveryMode property.
    public enum DeliveryMode {
        /// Client may get several image results when the call is asynchronous or will get one result when the call is synchronous
        ///
        /// If the isSynchronous property is false, Photos may call the resultHandler block (that you specified in the requestImage(for:targetSize:contentMode:options:resultHandler:) method more than once. Photos may call your result handler once to provide a low-quality image suitable for displaying temporarily while it prepares a high-quality image. If low-quality image data is immediately available, this first call may occur before the requestImage(for:targetSize:contentMode:options:resultHandler:) method returns. When the high-quality image is ready, Photos calls your result handler again to provide it.
        ///
        /// If the image manager has already cached the requested image, or if the isSynchronous property is true, Photos calls your result handler only once.
        case opportunistic
        /// Client will get one result only and it will be as asked or better than asked (sync requests are automatically processed this way regardless of the specified mode)
        ///
        /// If the isSynchronous property is true or if using the requestImageData(for:options:resultHandler:) method, this behavior is the default and only option (that is, specifying other delivery mode options has no effect).
        case highQualityFormat
        /// Client will get one result only and it may be degraded
        ///
        /// Photos calls your resultHandler block once. If a high-quality image cannot be loaded quickly, the result handler provides a low-quality image. Check the PHImageResultIsDegradedKey key in the info dictionary to determine the quality of image provided to the result handler.
        ///
        /// This option is available only if the isSynchronous property is false.
        case fastFormat
    }

}
