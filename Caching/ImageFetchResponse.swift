#if os(iOS)
import UIKit
public typealias Image = UIImage
#else
import AppKit
public typealias Image = NSImage
#endif

/**
 If you request an image whose data is not on the local device, and you have enabled downloading with the isNetworkAccessAllowed property, calls your block periodically to report progress on an arbitrary serial queue. Dispatch to the main thread if your handler needs to update the user interface.
 */
public typealias AssetImageProgressHandler = (Result<Double, Error>) -> Void

public struct ImageFetchResponse {

    public struct Source: OptionSet {
        public let rawValue: UInt
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        public static let local = Source(rawValue: 1 << 0)
        public static let remote = Source(rawValue: 1 << 1)
    }

    /// The resulting image or nil if the image couldn't be fetched
    public var image: Image?

    /// The result image is a low-quality substitute for the requested image
    public var isDegraded: Bool

    /// The means by which the asset was fetched
    public var source: Source

}

